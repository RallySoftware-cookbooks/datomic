require_relative 'spec_helper'

describe 'datomic::default' do
  describe port(4334) do
    it { should_not be_listening }
  end

  describe file('/home/datomic/datomic-free-0.8.4215/bin/datomic') do
    it { should be_file }
  end
end
