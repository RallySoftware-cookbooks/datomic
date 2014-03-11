require_relative '../spec_helper'

describe 'datomic_test::install' do
  let(:memory) { '84g' }
  let(:hostname) { 'myhostname' }
  let(:datomic_user) { 'datomic' }
  let(:license_key) { 'asdfaqwer12341234aasdfa12341341adfasdfaf' }
  let(:write_concurrency) { 42 }
  let(:read_concurrency) { 69 }
  let(:memcached_hosts) { "rad-host:1234" }
  let(:memory_index_threshold) { '314m' }
  let(:memory_index_max) { '99m' }
  let(:object_cache_max) { '22g' }
  let(:riak_host) { 'bld-riak-01' }
  let(:riak_bucket) { 'buckethead' }

  subject(:chef_run) do
    ChefSpec::Runner.new(step_into: ['datomic'], log_level: :error) do |node|
      node.automatic_attrs[:hostname] = hostname
      node.set[:datomic][:memory] = memory
      node.set[:datomic][:datomic_license_key] = license_key
      node.set[:datomic][:protocol] = 'riak'
      node.set[:datomic][:free] = false
      node.set[:datomic][:user] = datomic_user
      node.set[:datomic][:concurrency][:read] = read_concurrency
      node.set[:datomic][:concurrency][:write] = write_concurrency
      node.set[:datomic][:memcached_hosts] = memcached_hosts
      node.set[:datomic][:memory_index_threshold] = memory_index_threshold
      node.set[:datomic][:memory_index_max] = memory_index_max
      node.set[:datomic][:object_cache_max] = object_cache_max
      node.set[:datomic][:riak_host] = riak_host
      node.set[:datomic][:riak_bucket] = riak_bucket
    end.converge described_recipe
  end

  it { should create_template("/home/#{datomic_user}/datomic/transactor.properties").with(
         owner: datomic_user,
         group: datomic_user,
         mode: 00755,
         variables: {
           hostname: hostname,
           sql_url: nil,
           sql_user: nil,
           sql_password: nil,
           license_key: license_key,
           protocol: 'riak',
           write_concurrency: 42,
           read_concurrency: 69,
           memcached_hosts: "rad-host:1234",
           memory_index_threshold: memory_index_threshold,
           memory_index_max: memory_index_max,
           object_cache_max: object_cache_max,
           metrics_callback: nil,
           riak_host: riak_host,
           riak_bucket: riak_bucket
         }
      )
     }

end
