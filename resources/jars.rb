actions :install
default_action :install

attribute :jars, :kind_of => Array, :default => []
attribute :lib_dir, :kind_of => [String, File], :required => true
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true
