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

# # Configure firewall
# firewall 'default' do
#   action :install
# end

# # Allow SSH so we don't lock ourselves out
# firewall_rule 'ssh' do
#   port     22
#   command  :allow
#   action :create
# end

# # Allow HTTP
# firewall_rule 'http' do
#   port     80
#   command  :allow
#   action :create
#   only_if { node['lits_vm']['allow_web_traffic'] }
# end

# Create and start MySQL instance
mysql_service node['mysql']['service_name'] do
  bind_address node['mysql']['bind_address']
  version node['mysql']['version']
  initial_root_password node['mysql']['initial_root_password']
  action [:create, :start]
  only_if { node['lits_vm']['install_mysql'] }
end

if node['lits_vm']['install_nginx']
  # Install nginx
  include_recipe "nginx" 
  # create default web directory
  directory node['nginx']['default_root'] do
    group node['nginx']['user']
    owner node['nginx']['user']
    recursive true
  end
end 

# Node.js
include_recipe 'nodejs' if node['lits_vm']['install_nodejs']
nodejs_npm node['lits_vm']['npm_modules'] if !node['lits_vm']['npm_modules'].nil?

# Java
include_recipe 'java' if node['lits_vm']['install_java']

# Elasticsearch
include_recipe 'elasticsearch' if node['lits_vm']['install_elasticsearch']

if node['lits_vm']['install_elasticsearch']
  # Install php manually because the php cookbook doesn't work nicely with php-fpm???
  %w(php php-fpm php-pdo php-mysql php-xml php-mbstring php-apc php-gearman php-ldap).each do |pkg|
    package pkg
  end
  
  # Declare php-fpm service
  service 'php-fpm' do
    service_name 'php-fpm'
    supports start: true, stop: true, restart: true, reload: true
  end
end


package node['lits_vm']['additional_packages'] if !node['lits_vm']['additional_packages'].nil?

#FFmpeg
tar_extract 'http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz' do
  target_dir '/usr/local'
  compress_char ''
  creates '/usr/local/ffmpeg-3.0-64bit-static'
end

link '/usr/local/bin/ffmpeg' do
  to '/usr/local/ffmpeg-3.0-64bit-static/ffmpeg'
end