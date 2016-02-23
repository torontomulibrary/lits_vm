#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Enable Firewall
include_recipe 'firewalld' # RHEL / Centos specific

# Configure sshd
openssh_server node['sshd']['config_file'] do
  cookbook 'lits_vm'
  source 'sshd_config.erb'
end

# Configure firewall
firewalld_service 'http' do 
  action :add
  zone   'public'
end