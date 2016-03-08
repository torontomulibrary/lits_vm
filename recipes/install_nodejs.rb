#
# Cookbook Name:: lits_vm
# Recipe:: install_nodejs
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Node.js
include_recipe 'nodejs'
nodejs_npm node['lits_vm']['npm_modules'] unless node['lits_vm']['npm_modules'].nil?
