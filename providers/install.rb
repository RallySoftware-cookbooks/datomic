use_inline_resources

include DatomicLibrary::Mixin::Attributes
include DatomicLibrary::Mixin::Status

  def download
    remote_file local_file_path do
      source datomic_download_url
      owner username
      group username
      checksum node[:datomic][:checksum]
    end

    execute "unzip #{local_file_path} -d #{home_dir}" do
      cwd download_dir
      not_if { ::File.exists?(temporary_zip_dir) }
    end

    execute "chown -R #{username}:#{username} #{temporary_zip_dir}"

    link datomic_run_dir do
      to temporary_zip_dir
      owner username
      group username
    end

    append_if_no_line "assign DATOMIC_HOME environment variable" do
      path node[:datomic][:environment_file]
      line "DATOMIC_HOME=#{datomic_run_dir}"
    end

    directory "#{datomic_run_dir}/log" do
      recursive true
    end

    directory ::File.dirname(node[:datomic][:log_directory]) do
      recursive true
    end

    link node[:datomic][:log_directory] do
      to "#{datomic_run_dir}/log"
    end

  end

action :download do
  download
end

action :console do
  download

  run_dir = datomic_run_dir

  should_destroy = is_running? && version_changing?

  aws_access_key_id = node[:datomic][:aws_access_key_id]
  aws_secret_key    = node[:datomic][:aws_secret_key]
  console_alias     = node[:datomic][:console_alias]
  console_port      = node[:datomic][:console_port]
  console_uri       = node[:datomic][:console_uri]

  template "#{run_dir}/datomic_console.pill" do
    source 'datomic_console.pill.erb'
    mode     "0640"
    aws_keys = "env AWS_ACCESS_KEY_ID='#{aws_access_key_id}' AWS_SECRET_KEY='#{aws_secret_key}'" unless aws_access_key_id.nil? || aws_secret_key.nil?
    variables ({
      :log_file_application => "#{node[:datomic][:log_directory]}/datomic_console.log",
      :name                 => 'datomic_console',
      :start_command        => "#{aws_keys} #{run_dir}/bin/console -p #{console_port} #{console_alias} #{console_uri}",
      :working_dir          => run_dir,
    })
  end

  bluepill_service 'datomic_console' do
    action [:enable, :load, :start]
    Chef::Resource::BluepillService.respond_to?(:conf_dir) ? conf_dir(run_dir) : node.set['bluepill']['conf_dir'] = run_dir
  end

  # Operational aid for managing the Datomic Console
  link "#{node[:datomic][:local_bin_directory]}/bluepill" do
    to node[:bluepill][:bin]
  end
end

action :install do

  download

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
    cookbook 'datomic'
    mode 00755
    variables({
      :hostname => node[:hostname],
      :sql_user => node[:datomic][:sql_user],
      :sql_password => node[:datomic][:sql_password],
      :sql_url => node[:datomic][:sql_url],
      :license_key => node[:datomic][:datomic_license_key],
      :protocol => protocol,
      :write_concurrency => node[:datomic][:concurrency][:write],
      :read_concurrency => node[:datomic][:concurrency][:read],
      :memcached_hosts => node[:datomic][:memcached_hosts]
    })
  end

  run_dir = datomic_run_dir

  should_destroy = is_running? && version_changing?

  java_service 'datomic' do
    action [:stop, :disable]
    only_if { should_destroy }
  end

  java_service 'datomic' do
    action [:create, :enable, :load, :start]
    user username
    working_dir run_dir
    standard_options({:server => nil})
    main_class 'clojure.main'
    classpath Proc.new { Mixlib::ShellOut.new('bin/classpath', :cwd => run_dir).run_command.stdout.strip }
    args(['--main', 'datomic.launcher', 'transactor.properties'])
    pill_file_dir run_dir
    log_file "#{run_dir}/datomic.log"
    only_if { version_changing? }
    start_retries node[:datomic][:start_retries]
    start_delay node[:datomic][:start_delay]
    start_check Proc.new { Mixlib::ShellOut.new('netstat -tunl | grep -- 4334').run_command.stdout =~ /LISTEN/ }
  end

  java_service 'datomic' do
    action :restart
    only_if { is_running? && !version_changing? }
  end

end
