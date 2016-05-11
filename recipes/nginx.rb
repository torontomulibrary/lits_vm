#
# Cookbook Name:: lits_vm
# Recipe:: nginx
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'

# create empty default root directory
directory '/var/www'
directory node['nginx']['default_root'] do
  owner node['nginx']['user']
  group node['nginx']['group']
end

# create default server that sends empty response on bad hostname
virtual_host 'default_server' do
  listen '80 default'
  server_name '_'
  server_config [
    { name: 'return', value: '444' }
  ]
  action [:create, :disable, :enable]
end

include_recipe 'lits_vm::configure_nginx_sites' if node['lits_vm']['configure_nginx_sites']
