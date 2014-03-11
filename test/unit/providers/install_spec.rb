require_relative '../spec_helper'

describe 'datomic_test::install' do
  let(:memory) { '84g' }
  let(:hostname) { 'myhostname' }
  let(:sql_url) { 'http://www.mylittleponies.com/rainbowdash' }
  let(:sql_user) { 'Steve Dave' }
  let(:sql_password) { 'youtellem' }
  let(:datomic_user) { 'datomic' }
  let(:license_key) { 'asdfaqwer12341234aasdfa12341341adfasdfaf' }
  let(:datomic_run_dir) { "/home/#{datomic_user}/datomic"}
  let(:write_concurrency) { 42 }
  let(:read_concurrency) { 69 }
  let(:memcached_hosts) { "rSad-host:1234" }

  let(:memory_index_threshold) { '314m' }
  let(:memory_index_max) { '99m' }
  let(:object_cache_max) { '22g' }

  let(:running) { false }
  let(:changing) { false }

  let(:rendered_file) { "/home/#{datomic_user}/datomic/transactor.properties" }

  let(:metrics_callback) { 'my-ns/my-callback' }
  let(:extra_jars) { ['http://google.com/extra.jar'] }

  subject(:chef_run) do
    ChefSpec::Runner.new(step_into: ['datomic', 'datomic_jars'], log_level: :error) do |node|
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
      node.set[:datomic][:memory_index_threshold] = memory_index_threshold
      node.set[:datomic][:memory_index_max] = memory_index_max
      node.set[:datomic][:object_cache_max] = object_cache_max
      node.set[:datomic][:metrics_callback] = metrics_callback
      node.set[:datomic][:extra_jars] = extra_jars
    end.converge described_recipe
  end

  it { should create_template(rendered_file).with(
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
           write_concurrency: write_concurrency,
           read_concurrency: read_concurrency,
           memcached_hosts: memcached_hosts,
           memory_index_threshold: memory_index_threshold,
           memory_index_max: memory_index_max,
           object_cache_max: object_cache_max,
           metrics_callback: metrics_callback,
           riak_host: nil,
           riak_bucket: nil
  }) }

  it { should render_file(rendered_file).with_content("write-concurrency=#{write_concurrency}") }
  it { should render_file(rendered_file).with_content("memcached=#{memcached_hosts}") }
  it { should render_file(rendered_file).with_content("metrics-callback=#{metrics_callback}") }

  context 'when memcached is not set' do
    let(:memcached_hosts) { nil }
    it { should render_file(rendered_file).with_content("write-concurrency=#{write_concurrency}") }
    it { should_not render_file(rendered_file).with_content('memcached') }
  end

  let(:node) { chef_run.node }
  let(:local_file_path) { "#{Chef::Config[:file_cache_path]}/datomic-free-#{node[:datomic][:version]}.zip" }

  it { should create_remote_file(local_file_path).with(
         owner: datomic_user,
         checksum: node[:datomic][:checksum]
  )}

  let(:extra_jars_path) { "/home/#{datomic_user}/datomic/lib/extra.jar" }
  it { should create_remote_file(extra_jars_path).with(
         owner: datomic_user
  )}

  it { should run_execute("unzip #{local_file_path} -d /home/datomic").with(
         :cwd => Chef::Config[:file_cache_path]
  )}
end
