#
# Cookbook Name:: lits_vm
# Recipe:: elasticsearch
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Elasticsearch requires java
include_recipe 'lits_vm::java'
include_recipe 'elasticsearch'
