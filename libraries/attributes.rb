module DatomicLibrary
  module Mixin
    module Attributes

      def username
        new_resource.name
      end

      def home_dir
        "/home/#{username}"
      end

      def datomic_run_dir
        "#{home_dir}/datomic"
      end

      def download_dir
        Chef::Config[:file_cache_path]
      end

      def license_type
        node[:datomic][:free] ? 'free' : 'pro'
      end

      def full_version
        "#{license_type}-#{node[:datomic][:version]}"
      end

      def local_file_path
        "#{download_dir}/datomic-#{full_version}.zip"
      end

      def datomic_download_url
        node[:datomic][:download_url] || "https://my.datomic.com/downloads/#{license_type}/#{node[:datomic][:version]}"
      end

      def temporary_zip_dir
        "#{home_dir}/datomic-#{full_version}"
      end

    end
  end
end
