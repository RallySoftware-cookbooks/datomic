require_relative 'spec_helper'

describe 'datomic::default' do
  let(:ojdbc_jar_url) { 'http://www.oracle.com/ojdbc_11.0.2.jar' }
  let(:memory) { '84g' }
  let(:hostname) { 'myhostname' }
  let(:sql_url) { 'http://www.mylittleponies.com/rainbowdash' }
  let(:sql_user) { 'Steve Dave' }
  let(:sql_password) { 'youtellem' }
  let(:datomic_user) { 'theuser' }
  let(:license_key) { 'asdfaqwer12341234aasdfa12341341adfasdfaf' }
  let :chef_runner do
    ChefSpec::Runner.new do |node|
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
    end
  end

  let(:chef_run) { chef_runner.converge 'datomic::default' }
  let(:node) { chef_run.node }

  subject { chef_run }

  let(:ojdbc_jar_path) { "/home/#{datomic_user}/datomic/lib/ojdbc.jar" }

  # it { should create_remote_file(ojdbc_jar_path).with(:owner => datomic_user) }

  # context 'transactor.properties template' do
  #   subject { chef_run.template("/home/#{datomic_user}/datomic/transactor.properties") }

  #   its(:owner) { should eql datomic_user }
  #   its(:group) { should eql datomic_user }
  #   its(:mode)  { should eql 00755 }

  #   it 'should use variables' do
  #     subject.variables[:hostname].should eql hostname
  #     subject.variables[:sql_url].should eql sql_url
  #     subject.variables[:sql_user].should eql sql_user
  #     subject.variables[:sql_password].should eql sql_password
  #     subject.variables[:license_key].should eql license_key
  #     subject.variables[:protocol].should eql 'sql'
  #   end
  # end
end

