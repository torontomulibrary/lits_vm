#
# Cookbook Name:: lits_vm
# Provider:: virtual_host
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

def whyrun_supported?
  true
end

action :create do
  t = template "#{node['nginx']['dir']}/sites-available/#{new_resource.vhost_name}" do
    source 'nginx-site.erb'
    variables(
      listen: new_resource.listen,
      server_name: new_resource.server_name || new_resource.vhost_name,
      php_fpm_socket: new_resource.php_fpm_socket,
      server_config: new_resource.server_config,
      location_blocks: new_resource.location_blocks
    )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

action :enable do
  execute "nxensite #{new_resource.vhost_name}" do
    command "#{node['nginx']['script_dir']}/nxensite #{new_resource.vhost_name}"
    notifies :reload, 'service[nginx]', :delayed
    not_if do
      ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.vhost_name}") ||
        ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/000-#{new_resource.vhost_name}")
    end
  end
end

action :disable do
  execute "nxdissite #{new_resource.vhost_name}" do
    command "#{node['nginx']['script_dir']}/nxdissite #{new_resource.vhost_name}"
    notifies :reload, 'service[nginx]', :delayed
    only_if do
      ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.vhost_name}") ||
        ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/000-#{new_resource.vhost_name}")
    end
  end
end
