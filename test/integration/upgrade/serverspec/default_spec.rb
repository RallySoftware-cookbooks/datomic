require_relative 'spec_helper'

describe 'datomic::default' do
  describe port(4334) do
    it { should be_listening }
  end

  describe command('ps auxw | grep -v grep | grep datomic | grep transactor') do
    it { should return_exit_status(0) }
    it { should return_stdout(/datomic-free-transactor-0\.9\.4324/) }
  end
end
