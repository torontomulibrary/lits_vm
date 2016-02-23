#
# Cookbook Name:: lits_vm
# Recipe:: additional_packages
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node['lits_vm']['additional_packages'].each do |pkg|
  package pkg
end