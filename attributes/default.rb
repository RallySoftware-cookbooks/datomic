default[:datomic][:version] = '0.9.5078'
default[:datomic][:free] = true

default[:datomic][:checksum] = '6272baf2de71b78bd07cbddd8e1a29b12520ac7a4d09a39791a9f2f2460563e8'
default[:datomic][:user] = 'datomic'
default[:datomic][:protocol] = 'free'

default[:datomic][:jmx_port] = 5111

default[:datomic][:ojdbc_jar_url] = nil
default[:datomic][:ojdbc_jar_checksum] = nil
default[:datomic][:extra_jars] = nil
default[:datomic][:sql_user] = nil
default[:datomic][:sql_password] = nil
default[:datomic][:sql_url] = nil

default[:datomic][:datomic_license_key] = nil

default[:datomic][:metrics_callback] = nil

default[:datomic][:java][:'-X'][:ms] = '4g'
default[:datomic][:java][:'-X'][:mx] = '4g'
default[:datomic][:java][:'-XX'][:NewRatio] = '4'
default[:datomic][:java][:'-XX'][:SurvivorRatio] = '8'
default[:datomic][:java][:'-XX'][:UseConcMarkSweepGC] = true
default[:datomic][:java][:'-XX'][:UseParNewGC] = true
default[:datomic][:java][:'-XX'][:CMSParallelRemarkEnabled] = true
default[:datomic][:java][:'-XX'][:CMSInitiatingOccupancyFraction] = '60'
default[:datomic][:java][:'-XX'][:UseCMSInitiatingOccupancyOnly] = true
default[:datomic][:java][:'-XX'][:CMSScavengeBeforeRemark] = true

default[:datomic][:java][:'-D'][:'com.sun.management.jmxremote']
default[:datomic][:java][:'-D'][:'com.sun.management.jmxremote.port'] = node[:datomic][:jmx_port]
default[:datomic][:java][:'-D'][:'com.sun.management.jmxremote.ssl'] = false
default[:datomic][:java][:'-D'][:'com.sun.management.jmxremote.authenticate'] = false

default[:datomic][:concurrency][:write] = 4
default[:datomic][:concurrency][:read] = 8

default[:datomic][:memcached_hosts] = nil

default[:datomic][:start_retries] = 200
default[:datomic][:start_delay] = 1
default[:datomic][:stop_retries] = 200
default[:datomic][:stop_delay] = 1

default[:datomic][:memory_index_threshold] = '512m'
default[:datomic][:memory_index_max] = '1g'
default[:datomic][:object_cache_max] = '2g'

default[:bluepill][:version] = '0.0.68'
