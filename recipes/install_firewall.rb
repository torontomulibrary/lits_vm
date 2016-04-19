# Cookbook Name:: lits_vm
# Recipe:: install_firewall
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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
