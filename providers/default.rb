use_inline_resources

include DatomicLibrary::Mixin::Attributes
include DatomicLibrary::Mixin::Status

action :install do
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

  protocol = node[:datomic][:protocol]

  datomic_jars 'Install extra jars' do
    jars node[:datomic][:extra_jars]
    lib_dir "#{datomic_run_dir}/lib"
    owner username
    group username
  end

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

  riak_host = node[:datomic][:riak_host]
  riak_bucket = node[:datomic][:riak_bucket]

  if(protocol == 'riak')
    raise 'You must set node[:datomic][:riak_host]' if riak_host.nil?
    raise 'You must set node[:datomic][:riak_bucket]' if riak_bucket.nil?
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
      :memcached_hosts => node[:datomic][:memcached_hosts],
      :memory_index_threshold => node[:datomic][:memory_index_threshold],
      :memory_index_max => node[:datomic][:memory_index_max],
      :object_cache_max => node[:datomic][:object_cache_max],
      :metrics_callback => node[:datomic][:metrics_callback],
      :riak_host => riak_host,
      :riak_bucket => riak_bucket
    })
  end
end


action :start do
  run_dir = datomic_run_dir # assign so that it can be passed into the proc
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
    start_retries node[:datomic][:start_retries]
    start_delay node[:datomic][:start_delay]
    start_check { is_running? }
    not_if { is_running? }
  end
end

action :stop do
  java_service 'datomic' do
    action :stop
    stop_retries node[:datomic][:stop_retries]
    stop_delay node[:datomic][:stop_delay]
    only_if { is_running? }
  end
end

action :restart do
  java_service 'datomic' do
    action :restart
  end
end