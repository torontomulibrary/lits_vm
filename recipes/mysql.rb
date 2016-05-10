# Cookbook Name:: lits_vm
# Recipe:: install_mysql
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create and start MySQL instance
mysql_service node['mysql']['service_name'] do
  bind_address node['mysql']['bind_address']
  version node['mysql']['version']
  initial_root_password node['mysql']['initial_root_password']
  action [:create, :start]
end

# Install mysql2_chef_gem to set up databases
mysql2_chef_gem 'default'

unless node['mysql']['databases'].nil?
  node['mysql']['databases'].each do |database, d|
    mysql_database database do
      connection(
        host:     node['mysql']['bind_address'],
        username: 'root',
        socket:   "/var/run/mysql-#{node['mysql']['service_name']}/mysqld.sock",
        password: node['mysql']['initial_root_password']
      )
      encoding  'utf8'
      collation 'utf8_unicode_ci'
    end

    # Create database user 'atom' and grant all priveleges
    mysql_connection_info = {
      host:     node['mysql']['bind_address'],
      username: 'root',
      password: node['mysql']['initial_root_password']
    }

    mysql_database_user d.user do
      connection      mysql_connection_info
      database_name   database
      password        d.password
      action :grant
    end
  end
end
