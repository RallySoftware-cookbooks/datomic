require_relative '../spec_helper'

describe 'datomic_test::install' do
  let(:ojdbc_jar_url) { 'http://www.oracle.com/ojdbc_11.0.2.jar' }
  let(:memory) { '84g' }
  let(:hostname) { 'myhostname' }
  let(:sql_url) { 'http://www.mylittleponies.com/rainbowdash' }
  let(:sql_user) { 'Steve Dave' }
  let(:sql_password) { 'youtellem' }
  let(:datomic_user) { 'theuser' }
  let(:license_key) { 'asdfaqwer12341234aasdfa12341341adfasdfaf' }
  let(:write_concurrency) { 42 }
  let(:read_concurrency) { 69 }
  let(:memcached_hosts) { "rad-host:1234" }
  let(:memory_index_threshold) { '314m' }
  let(:memory_index_max) { '99m' }
  let(:object_cache_max) { '22g' }

  subject(:chef_run) do
    ChefSpec::Runner.new(step_into: ['datomic'], log_level: :error) do |node|
      node.automatic_attrs[:hostname] = hostname
      node.set[:datomic][:memory] = memory
      node.set[:datomic][:ojdbc_jar_url] = ojdbc_jar_url
      node.set[:datomic][:sql_user] = sql_user
      node.set[:datomic][:sql_password] = sql_password
      node.set[:datomic][:sql_url] = sql_url
      node.set[:datomic][:datomic_license_key] = license_key
      node.set[:datomic][:protocol] = 'sql'
      node.set[:datomic][:free] = false
      node.set[:datomic][:user] = datomic_user
      node.set[:datomic][:concurrency][:read] = read_concurrency
      node.set[:datomic][:concurrency][:write] = write_concurrency
      node.set[:datomic][:memcached_hosts] = memcached_hosts
      node.set[:datomic][:memory_index_threshold] = memory_index_threshold
      node.set[:datomic][:memory_index_max] = memory_index_max
      node.set[:datomic][:object_cache_max] = object_cache_max
    end.converge described_recipe
  end

  let(:ojdbc_jar_path) { "/home/#{datomic_user}/datomic/lib/ojdbc.jar" }

  it { should create_remote_file(ojdbc_jar_path).with(owner: datomic_user) }

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
           protocol: 'sql',
           write_concurrency: 42,
           read_concurrency: 69,
           memcached_hosts: "rad-host:1234",
           memory_index_threshold: memory_index_threshold,
           memory_index_max: memory_index_max,
           object_cache_max: object_cache_max,
           metrics_callback: nil,
           riak_host: nil,
           riak_bucket: nil
         }
      )
     }

end
