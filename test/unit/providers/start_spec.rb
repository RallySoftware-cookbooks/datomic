require_relative '../spec_helper'

describe 'datomic_test::start' do
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
    it { should create_java_service('datomic').with(
           user: datomic_user,
           working_dir: datomic_run_dir,
           pill_file_dir: datomic_run_dir,
           log_file: "#{datomic_run_dir}/datomic.log"
    )}
    it { should enable_java_service 'start datomic' }
    it { should load_java_service 'start datomic' }
    it { should start_java_service 'start datomic' }
  end

  context 'when datomic is running' do
    let(:running) { true }

    it { should_not create_java_service('datomic').with(
           user: datomic_user,
           working_dir: datomic_run_dir,
           pill_file_dir: datomic_run_dir,
           log_file: "#{datomic_run_dir}/datomic.log"
    )}
    it { should_not enable_java_service 'start datomic' }
    it { should_not load_java_service 'start datomic' }
    it { should_not start_java_service 'start datomic' }
  end
end
