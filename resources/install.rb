actions :install, :download, :console
default_action :install

attribute :console_alias, :kind_of => String
attribute :console_port,  :kind_of => Fixnum
attribute :console_uri,   :kind_of => String
attribute :console_user,  :kind_of => String
attribute :datomic_user_name, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String

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
