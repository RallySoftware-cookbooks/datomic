require_relative '../spec_helper'

describe 'datomic_test::stop' do
  let(:datomic_user) { 'datomic' }
  let(:datomic_run_dir) { "/home/#{datomic_user}/datomic"}
  let(:runner) do
    ChefSpec::Runner.new(step_into: ['datomic'], log_level: :error) do |node|
      node.set[:datomic][:user] = datomic_user
    end
  end

  subject(:chef_run) do
    runner.converge described_recipe do
      Chef::Provider::Datomic.any_instance.stub(:version_changing?).and_return(false)
      Chef::Provider::Datomic.any_instance.stub(:is_running?).and_return(running)
    end
  end

  context 'when datomic is not running' do
    let(:running) { false }
    it { should_not stop_java_service datomic_user }
  end

  context 'when datomic is running' do
    let(:running) { true }
    it { should stop_java_service datomic_user }
  end
end
