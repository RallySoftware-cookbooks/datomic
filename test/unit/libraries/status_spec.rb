describe 'status' do

  let(:instance_name) { 'test_instance' }
  let(:new_resource) { Chef::Resource.new(instance_name) }

  let(:node) do
    node = Chef::Node.new
    node.set['bluepill']['bin'] = '/opt/chef/embedded/bin/bluepill'
    node
  end

  describe 'already_installed?' do

    subject do
      ::File.stub(:symlink?).and_return(symlink_exists)
      StatusLibraryWrapper.new(node, new_resource)
    end

    context 'link exists' do
      let(:symlink_exists) { true }
      its(:already_installed?) { should be true}
    end

    context 'link does not exist' do
      let(:symlink_exists) { false }
      its(:already_installed?) { should be false}
    end
  end

  describe 'is_running?' do

    let(:status) do
      status = double("status")
      expect(status).to receive(:exitstatus).and_return(status_code)
      status
    end

    subject do
      Mixlib::ShellOut.any_instance.stub(:run_command).and_return(status)
      StatusLibraryWrapper.new(node, new_resource)
    end

    context 'for non-zero exit status' do
      let(:status_code) { 1 }
      its(:is_running?) { should eql false }
    end

    context 'for zero exit status' do
      let(:status_code) { 0 }
      its(:is_running?) { should eql true }
    end

  end

  describe 'running_version' do

    let(:stdout) { nil }

    let(:status) do
      status = double("status")
      expect(status).to receive(:exitstatus).and_return(status_code)
      expect(status).to receive(:stdout).and_return(stdout) unless stdout.nil?
      status
    end

    subject do
      Mixlib::ShellOut.any_instance.stub(:run_command).and_return(status)
      StatusLibraryWrapper.new(node, new_resource)
    end

    context 'for no process running' do
      let(:status_code) { 1 }
      its(:running_version) { should eql nil}
    end

    context 'process running pro version' do
      let(:status_code) { 0 }
      let(:version) { '0.1.2' }
      let(:stdout) { "blah:blah:blah:datomic-transactor-pro-#{version}.jar:blah:blah:blah" }
      its(:running_version) { should eql version }
    end

    context 'process running free version' do
      let(:status_code) { 0 }
      let(:version) { '3.4.5' }
      let(:stdout) { "blah:blah:blah:datomic-transactor-free-#{version}.jar:blah:blah:blah" }
      its(:running_version) { should eql version }
    end

    context 'process running, version string not recognized' do
      let(:status_code) { 0 }
      let(:version) { '7' }
      let(:stdout) { "blah:blah:blah:datomic-transactor-free-#{version}.jar:blah:blah:blah" }
      its(:running_version) { should eql nil }
    end

  end

end

class StatusLibraryWrapper
  include Chef::Datomic::Status

  attr_reader :node, :new_resource

  def initialize(node, new_resource)
    @node = node
    @new_resource = new_resource
  end
end

