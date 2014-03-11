require_relative '../spec_helper'

describe 'datomic_test::restart' do
  let(:datomic_user) { 'datomic' }
  let(:datomic_run_dir) { "/home/#{datomic_user}/datomic"}

  subject(:chef_run) do
    ChefSpec::Runner.new(step_into: ['datomic', 'datomic_jars'], log_level: :error) do |node|
      node.set[:datomic][:user] = datomic_user
    end.converge described_recipe
  end

  context 'when starting datomic' do
    it { should restart_java_service datomic_user }
  end

end
