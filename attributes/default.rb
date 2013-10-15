default[:datomic][:version] = '0.8.4215'
default[:datomic][:free] = true

default[:datomic][:checksum] = '88fda52a9a19'
default[:datomic][:user] = 'datomic'
default[:datomic][:memory] = '4g'
default[:datomic][:protocol] = 'free'

default[:datomic][:ojdbc_jar_url] = nil
default[:datomic][:ojdbc_jar_checksum] = nil
default[:datomic][:sql_user] = nil
default[:datomic][:sql_password] = nil
default[:datomic][:sql_url] = nil

default[:datomic][:datomic_license_key] = nil

default[:datomic][:java_opts] = '-XX:NewRatio=4 -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:CMSInitiatingOccupancyFraction=60 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSScavengeBeforeRemark'
