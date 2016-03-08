# Cookbook Name:: lits_vm
# Recipe:: install_elasticsearch
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Elasticsearch requires java
include_recipe 'lits_vm::install_java'

# Elasticsearch
include_recipe 'elasticsearch'
