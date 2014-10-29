require_relative 'spec_helper'

describe 'datomic::default' do
  describe port(4334) do
    it { should be_listening }
  end

  describe command('ps auxw | grep -v grep | grep datomic | grep transactor') do
    its(:exit_status) { should eq(0) }
    its(:stdout) { should match(/datomic-free-transactor-0\.9\.4324/) }
  end
end
