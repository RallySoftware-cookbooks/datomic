require_relative 'spec_helper'

describe 'datomic::default' do
  let(:datomic_user) { 'theuser' }

  subject(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:datomic][:user] = datomic_user
    end.converge described_recipe
  end

  it { should include_recipe 'java_service' }

  it { should create_datomic_user datomic_user }

  it { should stop_datomic_instance datomic_user }
  it { should install_datomic_instance datomic_user }
  it { should start_datomic_instance datomic_user }

end
