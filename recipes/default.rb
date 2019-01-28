#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ssh-hardening::server'

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

# Install packages
package node['lits_vm']['packages']

# Searches data bag "users" for groups attribute "sysadmin".
# Places returned users in Unix group "sysadmin" with GID 2300.
users_manage 'sysadmin' do
  group_id 2300
  action [:remove, :create]
end

# Configure additional user groups
node['lits_vm']['users']['manage_groups'].each do |group|
  users_manage group do
    action [:remove, :create]
  end
end

# Configure sudo users
include_recipe 'sudo'

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
  action [:save, :restart]
end if rhel?

# Disable SELinux because it breaks things
if rhel?
  reboot 'now' do
    action :nothing
    reason 'Cannot continue Chef run without a reboot. Run converge to continue Chef run.'
    delay_mins 1
  end

  include_recipe 'selinux::_common'

  selinux_state 'SELinux Disabled' do
    guard_interpreter :bash
    action :disabled
    notifies :reboot_now, 'reboot[now]', :immediately
    not_if "getenforce | grep -qx 'Disabled'"
  end
end