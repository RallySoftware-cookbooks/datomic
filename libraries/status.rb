module DatomicLibrary
  module Mixin
    module Status
      include DatomicLibrary::Mixin::Attributes

      def already_installed?
        ::File.symlink?(datomic_run_dir)
      end

      def is_running?
        datomic_status.exitstatus == 0
      end

      def running_version
        if(is_running?)
          output = datomic_status.stdout
          match = output.match(/datomic-(pro|free)-transactor-(\d+\.\d+\.\d+)/)
          if match
            match[2]
          end
        end
      end

      def version_changing?
        version != running_version
      end

      private

      def datomic_status
        Mixlib::ShellOut.new('ps auxw | grep -v grep | grep datomic | grep transactor').run_command
      end
    end
  end
end
