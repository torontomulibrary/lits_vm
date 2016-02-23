#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# include_recipe 'yum-epel' # RHEL / Centos specific
include_recipe 'sshd'
include_recipe 'firewalld' # RHEL / Centos specific

# package 'git'
# package 'byobu'

# Configure SSHD
openssh_server node['sshd']['config_file'] do
  cookbook 'lits_vm'
  source 'sshd_config.erb'
end

# Open HTTP to public (port 80)
firewalld_service 'http' do 
  action :add
  zone   'public'
end