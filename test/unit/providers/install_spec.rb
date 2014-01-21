require_relative '../spec_helper'

describe 'datomic::default' do
  let(:memory) { '84g' }
  let(:hostname) { 'myhostname' }
  let(:sql_url) { 'http://www.mylittleponies.com/rainbowdash' }
  let(:sql_user) { 'Steve Dave' }
  let(:sql_password) { 'youtellem' }
  let(:datomic_user) { 'theuser' }
  let(:license_key) { 'asdfaqwer12341234aasdfa12341341adfasdfaf' }
  let(:datomic_run_dir) { "/home/#{datomic_user}/datomic"}
  let(:write_concurrency) { 42 }
  let(:read_concurrency) { 69 }
  let(:memcached_hosts) { "rad-host:1234" }

  let(:running) { false }
  let(:changing) { false }

  let(:runner) do
    ChefSpec::Runner.new(step_into: ['datomic_install'], log_level: :error) do |node|
      node.automatic_attrs[:hostname] = hostname
      node.set[:datomic][:memory] = memory
      node.set[:datomic][:sql_user] = sql_user
      node.set[:datomic][:sql_password] = sql_password
      node.set[:datomic][:sql_url] = sql_url
      node.set[:datomic][:datomic_license_key] = license_key
      node.set[:datomic][:user] = datomic_user
      node.set[:datomic][:concurrency][:write] = write_concurrency
      node.set[:datomic][:concurrency][:read] = read_concurrency
      node.set[:datomic][:memcached_hosts] = memcached_hosts
    end
  end
  subject(:chef_run) do
    runner.converge described_recipe do
      Chef::Provider::DatomicInstall.any_instance.stub(:is_running?).and_return(running)
      Chef::Provider::DatomicInstall.any_instance.stub(:version_changing?).and_return(changing)
    end
  end

  it { should create_template("/home/#{datomic_user}/datomic/transactor.properties").with(
         owner: datomic_user,
         group: datomic_user,
         mode: 00755,
         variables: {
           hostname: hostname,
           sql_url: sql_url,
           sql_user: sql_user,
           sql_password: sql_password,
           license_key: license_key,
           protocol: 'free',
           write_concurrency: 42,
           read_concurrency: 69,
           memcached_hosts: 'rad-host:1234'
  }) }

  let(:node) { chef_run.node }
  let(:local_file_path) { "#{Chef::Config[:file_cache_path]}/datomic-free-#{node[:datomic][:version]}.zip" }

  it { should create_remote_file(local_file_path).with(
         owner: datomic_user,
         checksum: node[:datomic][:checksum]
  )}


  it { should run_execute("unzip #{local_file_path} -d /home/theuser").with(
       :cwd => Chef::Config[:file_cache_path])
       }

  context 'when upgrading' do
    let(:running) { true }
    let(:changing) { true }

    it { should stop_java_service 'datomic' }
    it { should disable_java_service 'datomic' }
  end

  context 'when upgrading or installing' do
    let(:changing) { true }

    it { should create_java_service('datomic').with(
      user: datomic_user,
      working_dir: datomic_run_dir,
      pill_file_dir: datomic_run_dir,
      log_file: "#{datomic_run_dir}/datomic.log"
      ) }
    it { should enable_java_service('datomic') }
    it { should load_java_service('datomic') }
    it { should start_java_service('datomic') }
  end

  context 'when not upgrading and not running' do
    let(:running) { true }
    let(:changing) { false }

    it { should restart_java_service 'datomic' }
  end

end
