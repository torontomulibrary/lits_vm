#
# Cookbook Name:: lits_vm
# Recipe:: users
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create and delete users for node
node['lits_vm']['users'].each do |username, action|
  search('users', "id:#{username}") do |u|
    lits_vm_user u['id'] do
      username  u['id']
      password  u['password'] if u['password']
      ssh_keys  u['ssh_keys'] if u['ssh_keys']
      shell     u['shell'] if u['shell']
      comment   u['comment']
      action    action.to_sym
    end
  end
end

# Configure user groups
node['lits_vm']['user_groups'].each do |g, settings|
  group g do
    members settings['members']
    action settings['action'].to_sym
  end
end

# Configure sudo users
include_recipe 'sudo'
