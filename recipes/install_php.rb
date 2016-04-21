#
# Cookbook Name:: lits_vm
# Recipe:: install_php
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install php manually because the php cookbook doesn't work nicely
# with php-fpm
# TODO: un-hardcode these packages
%w(php php-fpm php-pdo php-mysql php-xml php-mbstring php-apc php-gearman php-ldap).each do |pkg|
  package pkg
end

# Declare php-fpm service
service 'php-fpm' do
  service_name 'php-fpm'
  supports start: true, stop: true, restart: true, reload: true
end

# Configure php-fpm pools
node['php']['fpm_pools'].each do |pool, v|
  template "#{node['php']['fpm_pooldir']}/#{pool}.conf" do
    source "#{pool}.php-fpm.erb"
    variables v
    notifies :restart, 'service[php-fpm]'
  end
end
