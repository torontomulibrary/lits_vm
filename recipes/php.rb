#
# Cookbook Name:: lits_vm
# Recipe:: php
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

begin
  search("#{node.name}_bags", 'bag_type:fpm_pool') do |fpm_pool|
    php_fpm_pool fpm_pool['name'] do
      listen fpm_pool['listen']
      process_manager fpm_pool['process_manager']
      max_children fpm_pool['max_children']
      additional_config fpm_pool['additional_config']
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "#{node.name}_fpm_pool data bag not found" do
    level :info
  end
end

# make sure the session dir is read/writeable by www user
directory '/var/lib/php/session' do
  group node['php']['fpm_group']
end
