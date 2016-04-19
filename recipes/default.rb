#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'chef-sugar::default'

package %w(curl git)

# Enable EPEL repository
include_recipe 'yum-epel'

# Configure sshd
openssh_server node['sshd']['config_file'] do
  cookbook 'lits_vm'
  source 'sshd_config.erb'
end

# Configure users
include_recipe 'users::sysadmins'

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

node['lits_vm']['components'].each do |component|
  include_recipe "lits_vm::install_#{component}"
end

package node['lits_vm']['additional_packages'] unless node['lits_vm']['additional_packages'].nil?
