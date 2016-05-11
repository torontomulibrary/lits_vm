#
# Cookbook Name:: lits_vm
# Recipe:: mysql
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install mysql2_chef_gem to set up databases
mysql2_chef_gem 'default'

search("#{node.name}_mysql", '*:*') do |mysql_service|
  # Create and start MySQL instance
  mysql_service mysql_service['id'] do
    bind_address mysql_service['bind_address']
    version mysql_service['version']
    initial_root_password mysql_service['initial_root_password']
    action [:create, :start]
  end

  # Define connection info hash
  mysql_connection_info = {
    host:      mysql_service['bind_address'],
    username: 'root',
    socket:   "/var/run/mysql-#{mysql_service['id']}/mysqld.sock",
    password: mysql_service['initial_root_password']
  }

  # For each database listed in the data bag
  mysql_service['databases'].each do |database|
    # create the database
    mysql_database database['database_name'] do
      connection mysql_connection_info
      encoding  'utf8'
      collation 'utf8_unicode_ci'
    end

    # create database user and grant all priveleges
    mysql_database_user database['user'] do
      connection      mysql_connection_info
      database_name   database['name']
      password        database['user_password']
      action :grant
    end
  end
end
