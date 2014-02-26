## Description
Download and start a datomic transactor. Creates a runit service for datomic.

## Requirements
### Platform
List the supported platforms from the metadata.rb file -
* Centos 6.4

### Dependencies
This cookbook includes 'java::default' and 'java_service::default'

## Attributes
### default
See `attributes/default.rb` for default values

* `node[:datomic][:version]` = Version of datomic to install
* `node[:datomic][:free]` = Boolean of whether to use the free or pro version
* `node[:datomic][:url]` = URL for datomic download server
* `node[:datomic][:checksum]` = checksum for datomic zip file
* `node[:datomic][:user]` = user to install datomic under
* `node[:datomic][:memory]` = Memory to allocate to the transactor
* `node[:datomic][:protocol]` = Transactor protocol to use
* `node[:datomic][:ojdbc_jar_url]` = URL to download oracle jdbc jar
* `node[:datomic][:ojdbc_jar_checksum]` = checksum for ojdbc jar
* `node[:datomic][:extra_jars]` = Extra jars to install to the datomic/lib
* `node[:datomic][:metrics_callback]` = Metrics function to set in transactor.properties
* `node[:datomic][:sql_user]` = user to connect to sql database with
* `node[:datomic][:sql_password]` = password to connect to sql database with
* `node[:datomic][:sql_url]` = sql database connection string
* `node[:datomic][:datomic_license_key]` = datomic license key
* `node[:datomic][:java_opts]` = additional options to specify to java process
* `node[:datomic][:concurrency][:write]` = Write concurrency.  Number of threads.  See datomic documentation.
* `node[:datomic][:concurrency][:read]` = Read concurrency.  Number of threads.  Suggest 2x write-concurrency.  See datomic documentation.
* `node[:datomic][:memcached_hosts]` = List of memcached hosts.  Format: host:port(,host:port)*

## Recipes
###default
* creates a datomic user
* Downloads and extracts the datomic zip
* creates a symlink for datomic
* create a runit service for datomic (datomic-service)

## License
Copyright (C) 2013 Rally Software Development Corp

Distributed under the MIT License.
