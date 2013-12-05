require_relative '../spec_helper'

describe 'DatomicLibrary::Mixin::Attributes' do

  let(:instance_name) { 'test_instance' }
  let(:new_resource) { DatomicResource.new(instance_name) }
  let(:download_dir) { Chef::Config[:file_cache_path] }
  let(:download_url) { nil }
  let(:free) { true }
  let(:version) { '12345' }

  let(:node) do
    node = Chef::Node.new
    node.set[:datomic][:free] = free
    node.set[:datomic][:version] = version
    node.set[:datomic][:download_url] = download_url
    node
  end

  subject { AttributeLibraryWrapper.new(node, new_resource) }

  its(:username) { should eql instance_name }

  its(:home_dir) { should eql "/home/#{instance_name}" }

  its(:datomic_run_dir) { should eql "/home/#{instance_name}/datomic" }

  its(:download_dir) { should eql download_dir }

  its(:temporary_zip_dir) { should eql "/home/#{instance_name}/datomic-free-#{version}" }

  context 'when node[:datomic][:free] is' do
    describe 'true' do
      let(:full_version) { "free-#{version}" }

      its(:license_type) { should eql 'free' }

      its(:full_version) { should eql full_version }

      its(:local_file_path) { should eql "#{download_dir}/datomic-#{full_version}.zip" }
    end

    describe 'false' do
      let(:free) { false }
      let(:full_version) { "pro-#{version}" }

      its(:license_type) { should eql 'pro' }

      its(:full_version) { should eql full_version }

      its(:local_file_path) { should eql "#{download_dir}/datomic-#{full_version}.zip" }
    end
  end

  context 'when download url' do
    describe 'is specified as node attribute' do
      let(:download_url) { 'http://download.datomic.com/foo.zip' }
      its(:datomic_download_url) { should eql download_url }
    end

    describe 'is not specified as node attribute' do
      its(:datomic_download_url) { should eql "https://my.datomic.com/downloads/#{subject.license_type}/#{version}" }
    end
  end

  context 'when version' do
    describe 'is taken from attribute' do
      its(:version) { should eql version }
    end

    describe 'is specified in resource' do
      let(:version) { '5678' }
      before(:each) { new_resource.version = version }

      its(:version) { should eql version }
    end
  end
end

class DatomicResource < Chef::Resource

  attr_accessor :version

  def initialize(name)
    super(name)
  end

end

class AttributeLibraryWrapper
  include DatomicLibrary::Mixin::Attributes

  attr_reader :node, :new_resource

  def initialize(node, new_resource)
    @node = node
    @new_resource = new_resource
  end
end
