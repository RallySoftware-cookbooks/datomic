require_relative 'spec_helper'

describe 'datomic::default' do
  describe port(4334) do
    it { should be_listening }
  end
end
