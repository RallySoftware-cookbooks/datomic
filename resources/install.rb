actions :install
default_action :install

attribute :datomic_user_name, :kind_of => String, :name_attribute => true

def running=(running)
  @running = running
end

def running?
  @running
end

def running_version=(version)
  @version = version
end

def running_version
  @version
end

def already_installed=(installed)
  @installed = installed
end

def already_installed?
  @installed
end
