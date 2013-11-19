use_inline_resources

action :create do

  username = new_resource.name
  user_home_dir = "/home/#{username}"
  datomic_run_dir = "#{user_home_dir}/datomic"

  java_service 'datomic' do
    action [:create, :enable, :load, :start]
    user username
    working_dir datomic_run_dir
    standard_options({:server => nil})
    main_class 'clojure.main'
    classpath Proc.new { Mixlib::ShellOut.new('bin/classpath', :cwd => datomic_run_dir).run_command.stdout.strip }
    args(['--main', 'datomic.launcher', 'transactor.properties'])
  end

end
