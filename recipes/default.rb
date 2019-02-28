#
# Cookbook Name:: lits_vm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# SSH Hardening
include_recipe 'ssh-hardening::server'

# Set up package manager for Debian
include_recipe 'apt' if debian?

# Enable Extra Packages for Enterprise Linux
if rhel?
  include_recipe 'yum-epel'
  include_recipe 'yum-webtatic' if node['lits_vm']['enable_webtatic']
end

# Installs required acme-client chef gem
include_recipe 'acme'

# Install Node.js
include_recipe 'nodejs'

# Install packages
package node['lits_vm']['packages']

# Configure users
include_recipe 'lits_vm::users'

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