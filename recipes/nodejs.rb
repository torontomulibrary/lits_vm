#
# Cookbook Name:: lits_vm
# Recipe:: nodejs
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nodejs'

node['lits_vm']['npm_modules'].each do |npm_package|
  nodejs_npm npm_package
end
