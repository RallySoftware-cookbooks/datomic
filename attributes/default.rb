default[:datomic][:version] = '0.8.4215'
default[:datomic][:free] = true

default[:datomic][:checksum] = '88fda52a9a19'
default[:datomic][:user] = 'datomic'
default[:datomic][:protocol] = 'free'

default[:datomic][:ojdbc_jar_url] = nil
default[:datomic][:ojdbc_jar_checksum] = nil
default[:datomic][:sql_user] = nil
default[:datomic][:sql_password] = nil
default[:datomic][:sql_url] = nil

default[:datomic][:datomic_license_key] = nil

default[:datomic][:java][:'-X'][:ms] = '4g'
default[:datomic][:java][:'-X'][:mx] = '6g'
default[:datomic][:java][:'-XX'][:NewRatio] = '4'
default[:datomic][:java][:'-XX'][:SurvivorRatio] = '8'
default[:datomic][:java][:'-XX'][:UseConcMarkSweepGC] = true
default[:datomic][:java][:'-XX'][:UseParNewGC] = true
default[:datomic][:java][:'-XX'][:CMSParallelRemarkEnabled] = true
default[:datomic][:java][:'-XX'][:CMSInitiatingOccupancyFraction] = '60'
default[:datomic][:java][:'-XX'][:UseCMSInitiatingOccupancyOnly] = true
default[:datomic][:java][:'-XX'][:CMSScavengeBeforeRemark] = true
