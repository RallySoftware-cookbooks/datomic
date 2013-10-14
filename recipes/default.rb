#
# Cookbook Name:: datomic
# Recipe:: default
#
# Copyright (c) 2013 Rally Software Development Corp
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'java'
include_recipe 'runit'

username = node[:datomic][:user]
protocol = node[:datomic][:protocol]

user username do
  action :create
end

download_dir = Chef::Config[:file_cache_path]
user_home_dir = node[:datomic][:user_home_dir]
local_file_path = "#{download_dir}/datomic-#{node[:datomic][:full_version]}.zip"

remote_file local_file_path do
	source node[:datomic][:url]
	owner username
	group username
  checksum node[:datomic][:checksum]
end

directory user_home_dir do
	owner username
	group username
	mode 00755
end

temporary_zip_dir = "#{user_home_dir}/datomic-#{node[:datomic][:full_version]}"

execute "unzip #{local_file_path} -d #{user_home_dir}" do
  cwd download_dir
  not_if { ::File.exists?(temporary_zip_dir) }   
end

execute "chown -R #{username}:#{username} #{user_home_dir}"

datomic_run_dir = "#{user_home_dir}/datomic"

link temporary_zip_dir do
  to datomic_run_dir
end

if(protocol == 'sql')
  ojdbc_jar_url = node[:datomic][:ojdbc_jar_url]

  raise 'You must set node[:datomic][:ojdbc_jar_url]' if ojdbc_jar_url.nil?
  raise 'The sql protocol requires a datomic license, specify with node[:datomic][:datomic_license_key]' if node[:datomic][:datomic_license_key].nil?

  ojdbc_file = "#{datomic_run_dir}/lib/ojdbc.jar"

  remote_file ojdbc_file do
    source ojdbc_jar_url
    owner username
    group username
  end
end

template "#{datomic_run_dir}/transactor.properties" do
  source 'transactor.properties.erb'
  owner username
  group username
  mode 00755
  variables(
    :hostname => node[:hostname],
    :sql_user => node[:datomic][:sql_user],
    :sql_password => node[:datomic][:sql_password],
    :sql_url => node[:datomic][:sql_url],
    :license_key => node[:datomic][:datomic_license_key],
    :protocol => protocol
  )
end

runit_service 'datomic-service' do
  default_logger true
end
