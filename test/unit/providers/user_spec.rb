require_relative '../spec_helper'

describe 'datomic_test::user' do
  let(:datomic_user) { 'datomic' }
  let(:user_home_dir) { "/home/#{datomic_user}" }

  subject(:chef_run) do
    ChefSpec::Runner.new(step_into: ['datomic_user']) do |node|
      node.set[:datomic][:user] = datomic_user
    end.converge described_recipe
  end

  it { should create_user datomic_user }

  it { should create_directory(user_home_dir).with(
         owner: datomic_user,
         mode: 00755
  )}

  it { should run_execute("chown -R #{datomic_user}:#{datomic_user} #{user_home_dir}") }
end
