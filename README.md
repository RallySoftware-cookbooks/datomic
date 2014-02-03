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
* `node[:datomic][:sql_user]` = user to connect to sql database with
* `node[:datomic][:sql_password]` = password to connect to sql database with
* `node[:datomic][:sql_url]` = sql database connection string
* `node[:datomic][:datomic_license_key]` = datomic license key
* `node[:datomic][:java_opts]` = additional options to specify to java process
* `node[:datomic][:concurrency][:write]` = Write concurrency.  Number of threads.  See datomic documentation.
* `node[:datomic][:concurrency][:read]` = Read concurrency.  Number of threads.  Suggest 2x write-concurrency.  See datomic documentation.
* `node[:datomic][:memcached_hosts]` = List of memcached hosts.  Format: host:port(,host:port)*
* `node[:datomic][:aws_access_key_id]` = AWS_ACCESS_KEY_ID for use by console
* `node[:datomic][:aws_secret_key]` = AWS_SECRET_KEY for use by console
* `node[:datomic][:console_alias]` = Console alias string per http://docs.datomic.com/console.html#sec-1
* `node[:datomic][:console_port]` = Console port integer per http://docs.datomic.com/console.html#sec-1 (default: 80)
* `node[:datomic][:console_uri]` = Console URI string per http://docs.datomic.com/console.html#sec-1
* `node[:datomic][:console_user]` = User name to run console under (default: root)

## Recipes
###console
* creates a datomic user
* Downloads and extracts the datomic zip
* creates a symlink for datomic
* create a runit service for Datomic Console http://docs.datomic.com/console.html

###default
* creates a datomic user
* Downloads and extracts the datomic zip
* creates a symlink for datomic
* create a runit service for datomic (datomic-service)

###download
* creates a datomic user
* Downloads and extracts the datomic zip
* creates a symlink for datomic

## License
Copyright (C) 2013 Rally Software Development Corp

Distributed under the MIT License.
