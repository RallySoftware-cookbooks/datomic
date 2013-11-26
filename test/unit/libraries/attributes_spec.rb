require_relative '../spec_helper'

describe 'attributes' do

  let(:instance_name) { 'test_instance' }
  let(:new_resource) { Chef::Resource.new(instance_name) }
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

  its(:username) { should eql 'test_instance' }

  its(:home_dir) { should eql "/home/test_instance"}

  its(:datomic_run_dir) { should eql "/home/test_instance/datomic" }

  its(:download_dir) { should eql download_dir }

  its(:temporary_zip_dir) { should eql "/home/test_instance/datomic-free-#{version}"}

  context 'free version' do

    describe 'is true' do
      let(:full_version) { "free-#{version}" }

      its(:license_type) { should eql 'free' }

      its(:full_version) { should eql full_version }

      its(:local_file_path) { should eql "#{download_dir}/datomic-#{full_version}.zip" }
    end

    describe 'is false' do
      let(:free) { false }
      let(:full_version) { "pro-#{version}" }

      its(:license_type) { should eql 'pro' }

      its(:full_version) { should eql full_version }

      its(:local_file_path) { should eql "#{download_dir}/datomic-#{full_version}.zip" }
    end

  end

  context 'download url' do

    describe 'specified as node attribute' do
      let(:download_url) { 'http://download.datomic.com/foo.zip' }
      its(:datomic_download_url) { should eql download_url }
    end

    describe 'is not specified as node attribute' do
      its(:datomic_download_url) { should eql "https://my.datomic.com/downloads/#{subject.license_type}/#{version}" }
    end
  end

end

class AttributeLibraryWrapper
  include Chef::Datomic::Attributes

  attr_reader :node, :new_resource

  def initialize(node, new_resource)
    @node = node
    @new_resource = new_resource
  end
end