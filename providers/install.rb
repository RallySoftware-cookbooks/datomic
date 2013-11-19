use_inline_resources

action :install do
  username = new_resource.name
  user_home_dir = "/home/#{username}"
  download_dir = Chef::Config[:file_cache_path]
  license_type = node[:datomic][:free] ? 'free' : 'pro'
  full_version = license_type + '-' + node[:datomic][:version]
  local_file_path = "#{download_dir}/datomic-#{full_version}.zip"
  datomic_download_url = node[:datomic][:download_url] || "https://my.datomic.com/downloads/#{license_type}/#{node[:datomic][:version]}"
  datomic_run_dir = "#{user_home_dir}/datomic"

  remote_file local_file_path do
    source datomic_download_url
    owner username
    group username
    checksum node[:datomic][:checksum]
  end

  temporary_zip_dir = "#{user_home_dir}/datomic-#{full_version}"

  execute "unzip #{local_file_path} -d #{user_home_dir}" do
    cwd download_dir
    not_if { ::File.exists?(temporary_zip_dir) }
  end

  execute "chown -R #{username}:#{username} #{user_home_dir}"

  link datomic_run_dir do
    to temporary_zip_dir
  end

  protocol = node[:datomic][:protocol]

  if(protocol == 'sql')
    ojdbc_jar_url = node[:datomic][:ojdbc_jar_url]

    raise 'You must set node[:datomic][:ojdbc_jar_url]' if ojdbc_jar_url.nil?
    raise 'The sql protocol requires a datomic license, specify with node[:datomic][:datomic_license_key]' if node[:datomic][:datomic_license_key].nil?

    ojdbc_file = "#{datomic_run_dir}/lib/ojdbc.jar"

    remote_file ojdbc_file do
      source ojdbc_jar_url
      owner username
      group username
      checksum node[:datomic][:ojdbc_jar_checksum]
    end
  end

  template "#{datomic_run_dir}/transactor.properties" do
    source 'transactor.properties.erb'
    owner username
    group username
    mode 00755
    variables(
      :hostname => node[:hostname],
      :sql_user => node[:datomic][:sql_user],
      :sql_password => node[:datomic][:sql_password],
      :sql_url => node[:datomic][:sql_url],
      :license_key => node[:datomic][:datomic_license_key],
      :protocol => protocol
    )
  end

end
