require_relative 'status'

class Chef
  module Datomic
    module Service

      include Chef::Datomic::Status

      def service_actions
        if datomic_already_installed?
          if datomic_version_installed?
            [:stop, :create, :enable, :load, :start]
            # notify_datomic_service(:stop)
            # create_datomic_service
          else
            if datomic_not_running?
              [:create, :enable, :load, :start]
              # create_datomic_service
            end
          end

          if datomic_not_running?
            [:restart]
            # notify_datomic_service(:restart)
          end
        else
          [:create, :enable, :load, :start]
          # create_datomic_service
        end
      end

      def run_necessary_actions
        service_actions.each do |action|
          log "Notifying datomic service to #{action}" do
            notifies action, "java-service[datomic]"
          end
        end
        # notify_datomic_service(service_actions)
        # if datomic_already_installed?
        #   if datomic_version_installed?
        #     notify_datomic_service(:stop)
        #     create_datomic_service
        #   else
        #     if datomic_not_running?
        #       create_datomic_service
        #     end
        #   end

        #   if datomic_not_running?
        #     notify_datomic_service(:restart)
        #   end
        # else
        #   create_datomic_service
        # end
      end

      def notify_datomic_service(*actions)
        actions.each do |action|
          log "Notifying datomic service to #{action}" do
            notifies action, "java-service[datomic]"
          end
        end
      end

      def create_datomic_service
        notify_datomic_service(:create, :enable, :load, :start)
      end

    end
  end
end
