#
# Cookbook Name:: lits_vm
# Recipe:: php
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install PHP using the community cookbook
include_recipe 'php'

# Install PECLs
node['lits_vm']['php']['pecls'].each do |pecl|
  php_pear pecl do
    action :install
    binary "pecl"
  end

  extensions = [ "#{pecl}.so" ]

  template "#{node['php']['ext_conf_dir']}/#{pecl}.ini" do
    source 'extension.ini.erb'
    cookbook 'lits_vm'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      name: pecl,
      extensions: extensions,
      directives: []
    )
  end
end

# Install PECLs with special configurations
if node['lits_vm']['php']['install_gearman_extension']
  include_recipe 'lits_vm::pecl_gearman'
end

if node['lits_vm']['php']['install_apcu_extension']
  include_recipe 'lits_vm::pecl_apcu'
end

# Set default socket for pdo_mysql extension
template "#{node['php']['ext_conf_dir']}/pdo_mysql.ini" do
  source 'extension.ini.erb'
  cookbook 'lits_vm'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    name: 'pdo_mysql',
    extensions: [ 'pdo_mysql.so' ],
    directives: {
      'default_socket' => '/var/run/mysql-default/mysqld.sock'
    }
  )
end

# Configure FPM pools
begin
  search("#{node.name}_bags", 'bag_type:fpm_pool') do |fpm_pool|
    php_fpm_pool fpm_pool['name'] do
      listen fpm_pool['listen']
      process_manager fpm_pool['process_manager']
      max_children fpm_pool['max_children']
      additional_config fpm_pool['additional_config']
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "#{node.name}_fpm_pool data bag not found" do
    level :info
  end
end

# Restart FPM service
service node['php']['fpm_service'] do
  action :restart
end

# make sure the session dir is read/writeable by www user
directory "#{node['lits_vm']['php']['fpm_session_dir']}" do
  recursive true
  group node['php']['fpm_group']
end
