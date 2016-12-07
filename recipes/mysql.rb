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

begin
  search("#{node.name}_bags", 'bag_type:mysql_service') do |service|
    # Configure MySQL service process
    mysql_service service['name'] do
      bind_address service['bind_address']
      version service['version']
      initial_root_password service['initial_root_password']
      action [:create, :start]
    end

    # Define connection info
    mysql_connection_info = {
      host:      service['bind_address'],
      username: 'root',
      socket:   "/var/run/mysql-#{service['name']}/mysqld.sock",
      password: service['initial_root_password']
    }

    # Create databases
    service['databases'].each do |database|
      mysql_database database['name'] do
        connection mysql_connection_info
        encoding  'utf8'
        collation 'utf8_unicode_ci'
      end
    end

    # Create users
    service['users'].each do |user|
      mysql_database_user user['username'] do
        connection mysql_connection_info
        password user['password']
        action :create
      end

      # Grant priveleges on databases to user
      user['databases'].each do |db_name|
        mysql_database_user user['username'] do
          connection mysql_connection_info
          database_name db_name
          privileges [:all]
          action :grant
        end
      end
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "#{node.name}_bags not found!" do
    level :info
  end
end
