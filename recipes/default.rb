#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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
end

# Install nginx
include_recipe "nginx"

# Node.js
include_recipe 'nodejs'

# Java
include_recipe 'java'

# Elasticsearch
include_recipe 'elasticsearch'

include_recipe 'lits_vm::additional_packages'