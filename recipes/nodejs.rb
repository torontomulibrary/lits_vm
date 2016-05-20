#
# Cookbook Name:: lits_vm
# Recipe:: nodejs
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nodejs'

nodejs_npm 'npm' do
  version 'latest'
end

node['lits_vm']['npm_modules'].each do |npm_package|
  nodejs_npm npm_package['name'] do
    version npm_package['version']
  end
end
