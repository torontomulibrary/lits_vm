#
# Cookbook Name:: lits_vm
# Recipe:: install_php
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php'

# Install extension packages
node['lits_vm']['php_extension_packages'].each do |pkg|
  package pkg
end

# configure pools
unless node['php']['fpm_pools'].nil?
  node['php']['fpm_pools'].each do |pool|
    php_fpm_pool pool['pool_name'] do
      listen pool['listen']
      process_manager pool['process_manager']
      max_children pool['max_children']
      additional_config pool['additional_config']
    end
  end
end

# make sure the session dir is read/writeable by www user
directory '/var/lib/php/session' do
  group node['php']['fpm_group']
end
