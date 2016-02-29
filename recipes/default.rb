#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package %w(curl git)

# Enable EPEL repository
include_recipe 'yum-epel'

# Configure sshd
openssh_server node['sshd']['config_file'] do
  cookbook 'lits_vm'
  source 'sshd_config.erb'
end

# Configure firewall
firewall 'default' do
  action :install
end

# Allow SSH so we don't lock ourselves out
firewall_rule 'ssh' do
  port     22
  command  :allow
  action :create
end

# Allow HTTP
firewall_rule 'http' do
  port     80
  command  :allow
  action :create
  only_if { node['lits_vm']['allow_web_traffic'] }
end

# Create and start MySQL instance
mysql_service node['mysql']['service_name'] do
  bind_address node['mysql']['bind_address']
  version node['mysql']['version']
  initial_root_password node['mysql']['initial_root_password']
  action [:create, :start]
  only_if { node['lits_vm']['install_mysql'] }
end

# Install nginx
include_recipe "nginx" if node['lits_vm']['install_nginx']

# Node.js
include_recipe 'nodejs' if node['lits_vm']['install_nodejs']
nodejs_npm node['lits_vm']['npm_modules'] if !node['lits_vm']['npm_modules'].nil?

# Java
include_recipe 'java' if node['lits_vm']['install_java']

# Elasticsearch
include_recipe 'elasticsearch' if node['lits_vm']['install_elasticsearch']

# Install PHP and extra packages
if node['lits_vm']['install_php']
  include_recipe 'php'
  package node['lits_vm']['php_packages'] !node['lits_vm']['php_packages'].nil?
end

# Enable php-fpm
php_fpm_pool "default" do
  action :install
  only_if { node['lits_vm']['install_php'] }
end

package node['lits_vm']['additional_packages'] if !node['lits_vm']['additional_packages'].nil?
