#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'sshd'

# Chef Sugar is a Gem & Chef Recipe that includes series of helpful sugar of
# the Chef core and other resources to make a cleaner, more lean recipe DSL,
# enforce DRY principles, and make writing Chef recipes an awesome experience!
# http://sethvargo.github.io/chef-sugar/
include_recipe 'chef-sugar'

include_recipe 'apt' if debian?

# Enable Extra Packages for Enterprise Linux
if rhel?
  include_recipe 'yum-epel'
  include_recipe 'yum-webtatic' if node['lits_vm']['enable_webtatic']
end

# Install Node.js
include_recipe 'nodejs'

# Always install curl and git because we need them all the time
package %w(curl git)

# Configure sysadmin users
# Searches data bag "users" for groups attribute "sysadmin".
# Places returned users in Unix group "sysadmin" with GID 2300.
users_manage 'sysadmin' do
  group_id 2300
  action [:remove, :create]
end
include_recipe 'sudo'

# Configure additional non-sudo users
node['lits_vm']['users']['manage_groups'].each do |group|
  users_manage group do
    action [:remove, :create]
    data_bag "#{node.name}_users"
  end
end

# Configure firewall
include_recipe 'firewall'
node['lits_vm']['firewall']['allow_ports'].each do |name, port|
  firewall_rule name do
    port port
    command :allow
  end
end
# Set permanent firewall rules if RHEL
firewall 'default' do
  action :save
end if rhel?

# Install specified additional packages
package node['lits_vm']['additional_packages']
