use_inline_resources

include DatomicLibrary::Mixin::Attributes

require 'etc'

action :create do

  user username

  directory home_dir do
    owner username
    group username
    mode 00755
  end

  execute "chown -R #{username}:#{username} #{home_dir}" do
    not_if { Etc.getpwuid(::File.stat(home_dir).uid).name == username }
  end

end
