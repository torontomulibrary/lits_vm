#
# Cookbook Name:: lits_vm
# Recipe:: elasticsearch
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-sugar'

# Elasticsearch requires java
include_recipe 'lits_vm::java'

# Bits to install + start ES from elasticsearch::default recipe
elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type node['elasticsearch']['install_type'].to_sym # since TK can't symbol.
end
elasticsearch_configure 'elasticsearch'
elasticsearch_service 'elasticsearch' do 
  action [ :configure, :start ]
end
