default[:datomic][:version] = '0.8.4215'
default[:datomic][:free] = true
license_type = node[:datomic][:free] ? 'free' : 'pro'
default[:datomic][:full_version] = license_type + '-' + default[:datomic][:version]
default[:datomic][:url] = "http://downloads.datomic.com/#{node[:datomic][:version]}/datomic-#{node[:datomic][:full_version]}.zip"

default[:datomic][:checksum] = '88fda52a9a19'
default[:datomic][:user] = 'datomic'
default[:datomic][:user_home_dir] = "/home/#{node[:datomic][:user]}"
default[:datomic][:memory] = '4g'
default[:datomic][:protocol] = 'free'

default[:datomic][:ojdbc_jar_url] = nil
default[:datomic][:sql_user] = nil
default[:datomic][:sql_password] = nil
default[:datomic][:sql_url] = nil

default[:datomic][:datomic_license_key] = nil

default[:datomic][:java_opts] = '-XX:NewRatio=4 -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:CMSInitiatingOccupancyFraction=60 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSScavengeBeforeRemark'
