require_relative 'spec_helper'

describe 'datomic::default' do
  let (:free) { false }
  let (:full_version) { 'pro-1.2.3' }
  let (:version) { '1.2.3' }
	let (:datomic_user) { 'theuser' }
  let (:checksum) { '88fda52a9bcd' }
  let (:user_home_dir) { "/home/#{datomic_user}" }
  let (:download_dir) { Chef::Config[:file_cache_path] }
  let (:local_file_path) { "#{download_dir}/datomic-#{full_version}.zip" }

	let :chef_runner do 
    ChefSpec::ChefRunner.new do |node|
      node.set[:datomic][:free] = free
      node.set[:datomic][:version] = version
      node.set[:datomic][:user] = datomic_user
      node.set[:datomic][:checksum] = checksum
    end
  end

  let(:chef_run) { chef_runner.converge 'datomic::default' }
  
  subject { chef_run }   

  it { should create_user datomic_user }

  it { should create_remote_file("#{local_file_path}").with(
    :owner => datomic_user,
    :checksum => checksum
    )}

  it { should create_directory(user_home_dir) }

  context 'install directory' do
  	subject { chef_run.directory(user_home_dir) }
  	its(:owner) { should be datomic_user }
  	its(:group) { should be datomic_user } 
  	its(:mode)  { should eql 00755 }
  end

  it { should execute_command("unzip #{local_file_path} -d #{user_home_dir}").with(:cwd => Chef::Config[:file_cache_path]) }

  it { should execute_command("chown -R #{datomic_user}:#{datomic_user} #{user_home_dir}") }
end

