require_relative 'spec_helper'

describe 'datomic::default' do
  describe port(4334) do
    it { should be_listening }
  end

  describe command('ps auxw | grep -v grep | grep datomic | grep transactor') do
    its(:exit_status) { should eq(0) }
    its(:stdout) { should match(/datomic-free-transactor-0\.8\.4215/) }
  end

  describe file('/home/datomic/datomic-free-0.8.4215/bin/logback.xml') do
    its(:content) { should match ".log.gz" }
    its(:content) { should match "<prudent>false" }
  end
end
