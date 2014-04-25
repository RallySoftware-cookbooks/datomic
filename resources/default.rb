actions :install, :start, :stop
default_action :install

attribute :datomic_user_name, :kind_of => String
attribute :version, :kind_of => String
attribute :checksum, :kind_of => String

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

def version_changing=(changing)
  @changing = changing
end

def version_changing?
  @changing
end