#
# Cookbook Name:: lits_vm
# Recipe:: nginx
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Configure nginx sites from data bags
include_recipe 'chef_nginx'
directory node['nginx']['default_root'] do
  recursive true
end
