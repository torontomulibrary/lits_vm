# Cookbook Name:: lits_vm
# Recipe:: install_nginx
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'

# Create default web directory
directory node['nginx']['default_root'] do
  group node['nginx']['user']
  owner node['nginx']['user']
  recursive true
end

# Create /vagrant/www
directory "#{node['lits_vm']['vagrant_share']}/www/" do
  recursive true
  only_if { vagrant? }
end

# Delete nginx directory and replace with symlink to vagrant share
directory node['nginx']['default_root'] do
  action :delete
  only_if { vagrant? }
end
link node['nginx']['default_root'] do
  to "#{node['lits_vm']['vagrant_share']}/www/"
  only_if { vagrant? }
end

node['nginx']['sites_enabled'].each do |site, v|
  nginx_site site do
    template "#{site}.nginx.erb"
    variables v
  end
end

service 'nginx' do
  action :reload
end
