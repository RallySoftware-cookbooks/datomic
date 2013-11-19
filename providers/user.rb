use_inline_resources

action :create do
  username = new_resource.name
  user_home_dir = "/home/#{username}"

  user username

  directory user_home_dir do
    owner username
    group username
    mode 00755
  end

end
