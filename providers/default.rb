require 'base64'

use_inline_resources

include DatomicLibrary::Mixin::Attributes
include DatomicLibrary::Mixin::Status

require 'etc'

action :install do

  encoded_credentials = Base64.encode64("#{download_user}:#{download_credential}")

  remote_file "downloading datomic-#{node[:datomic][:version]} to #{local_file_path}" do #~FC009
    path     local_file_path
    source   datomic_download_url
    headers  Hash.new('Basic' => "Basic #{encoded_credentials}")
    owner    username
    group    username
    checksum new_resource.checksum
    action   :create
  end

  execute "unzip #{local_file_path} -d #{home_dir}" do
    cwd download_dir
    not_if { ::File.exists?(temporary_zip_dir) }
  end

  execute "chown -R #{username}:#{username} #{temporary_zip_dir}" do
    not_if { Etc.getpwuid(::File.stat(temporary_zip_dir).uid).name == username }
  end

  datomic_jars 'Install extra jars' do
    jars node[:datomic][:extra_jars]
    lib_dir "#{temporary_zip_dir}/lib"
    owner username
    group username
  end

  protocol = node[:datomic][:protocol]
  if(protocol == 'sql')
    ojdbc_jar_url = node[:datomic][:ojdbc_jar_url]

    Chef::Application.fatal! 'You must set node[:datomic][:ojdbc_jar_url]' if ojdbc_jar_url.nil?
    Chef::Application.fatal! 'The sql protocol requires a datomic license, specify with node[:datomic][:datomic_license_key]' if node[:datomic][:datomic_license_key].nil?

    ojdbc_file = "#{temporary_zip_dir}/lib/ojdbc.jar"

    remote_file ojdbc_file do
      source ojdbc_jar_url
      owner username
      group username
      checksum node[:datomic][:ojdbc_jar_checksum]
      action :create_if_missing
    end
  end

  riak_host = node[:datomic][:riak_host]
  riak_bucket = node[:datomic][:riak_bucket]

  if(protocol == 'riak')
    Chef::Application.fatal! 'You must set node[:datomic][:riak_host]' if riak_host.nil?
    Chef::Application.fatal! 'You must set node[:datomic][:riak_bucket]' if riak_bucket.nil?
  end

  template "#{temporary_zip_dir}/transactor.properties" do
    source 'transactor.properties.erb'
    owner username
    group username
    cookbook 'datomic'
    mode 00755
    variables({
      :hostname => node[:fqdn],
      :sql_user => node[:datomic][:sql_user],
      :sql_password => node[:datomic][:sql_password],
      :sql_url => node[:datomic][:sql_url],
      :license_key => node[:datomic][:datomic_license_key],
      :protocol => protocol,
      :write_concurrency => node[:datomic][:concurrency][:write],
      :read_concurrency => node[:datomic][:concurrency][:read],
      :memcached_hosts => node[:datomic][:memcached_hosts],
      :memory_index_threshold => node[:datomic][:memory_index_threshold],
      :memory_index_max => node[:datomic][:memory_index_max],
      :object_cache_max => node[:datomic][:object_cache_max],
      :metrics_callback => node[:datomic][:metrics_callback],
      :riak_host => riak_host,
      :riak_bucket => riak_bucket
    })
    notifies :stop, 'datomic[stop datomic in preparation for start or restart]', :immediately
  end

  if node[:datomic][:service_install]
    run_dir = temporary_zip_dir # assign so that it can be passed into the proc
    java_service 'configure datomic' do
      service_name 'datomic'
      action [:create, :enable, :load]
      user username
      working_dir run_dir
      standard_options({:server => nil})
      main_class 'clojure.main'
      classpath Proc.new { Mixlib::ShellOut.new('bin/classpath', :cwd => run_dir).run_command.stdout.strip }
      args(['--main', 'datomic.launcher', 'transactor.properties'])
      pill_file_dir run_dir
      log_file "#{run_dir}/datomic.log"
      start_retries node[:datomic][:start_retries]
      start_delay node[:datomic][:start_delay]
      start_check { is_running? }
      notifies :stop, 'datomic[stop datomic in preparation for start or restart]', :immediately
    end

    datomic 'start datomic from install action' do
      action :start
    end

    link datomic_run_dir do
      to temporary_zip_dir
      owner username
      group username
    end
  end

  datomic 'stop datomic in preparation for start or restart' do
    action :nothing
  end

end

action :start do
  java_service 'start datomic' do
    service_name 'datomic'
    action [:start]
    not_if { is_running? }
  end
end

action :stop do
  java_service 'stop datomic' do
    service_name 'datomic'
    stop_retries node[:datomic][:stop_retries]
    stop_delay node[:datomic][:stop_delay]
    only_if { is_running? }
    action :stop
  end
end
