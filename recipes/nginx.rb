#
# Cookbook Name:: lits_vm
# Recipe:: nginx
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Configure nginx sites from data bags
include_recipe 'acme' # for SSL :)
include_recipe 'chef_nginx'
directory node['nginx']['default_root'] do
  recursive true
end

begin
  search("#{node.name}_bags", 'bag_type:nginx_site') do |ns|
    # create log files if missing
    file "/var/log/nginx/#{ns['name']}.access.log" do
      owner node['nginx']['user']
      group node['nginx']['group']
      mode '644'
      action :create_if_missing
    end
    file "/var/log/nginx/#{ns['name']}.error.log" do
      owner node['nginx']['user']
      group node['nginx']['group']
      mode '644'
      action :create_if_missing
    end

    # Self-signed certificate
    acme_selfsigned ns['hostname'] do
      crt "/etc/ssl/#{ns['hostname']}.crt"
      key "/etc/ssl/#{ns['hostname']}.key"
      not_if { ns['hostname'].nil? }
    end if ns['ssl']

    nginx_site ns['name'] do
      template 'nginx-site.erb'
      variables(
        blocks: ns['blocks']
      )
      action :enable
      notifies :reload, 'service[nginx]', :immediately
    end

    # Request the real certificate!
    acme_certificate ns['hostname'] do
      fullchain "/etc/ssl/#{ns['hostname']}.crt"
      chain     "/etc/ssl/#{ns['hostname']}-chain.crt"
      key       "/etc/ssl/#{ns['hostname']}.key"
      wwwroot   ns['wwwroot']
      owner node['nginx']['user']
      group node['nginx']['group']
      notifies :reload, 'service[nginx]'
    end if ns['ssl']
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "#{node.name}_nginx data bag not found" do
    level :info
  end
end
