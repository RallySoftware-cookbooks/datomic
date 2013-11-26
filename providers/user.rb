use_inline_resources

include Chef::Datomic::Attributes

action :create do
  # attributes = ::DatomicAttributes.new(node, new_resource)

  user username

  directory home_dir do
    owner username
    group username
    mode 00755
  end

  execute "chown -R #{username}:#{username} #{home_dir}"

end
