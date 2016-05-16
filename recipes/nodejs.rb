#
# Cookbook Name:: lits_vm
# Recipe:: nodejs
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nodejs'

nodejs_npm node['lits_vm']['npm_modules']
