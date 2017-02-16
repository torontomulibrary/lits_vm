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
  search("#{node.name}_bags", 'bag_type:nginx_site') do |site|
    # create log files if missing
    file "/var/log/nginx/#{site['name']}.access.log" do
      owner node['nginx']['user']
      group node['nginx']['group']
      mode '644'
      action :create_if_missing
    end
    file "/var/log/nginx/#{site['name']}.error.log" do
      owner node['nginx']['user']
      group node['nginx']['group']
      mode '644'
      action :create_if_missing
    end

    # Self-signed certificate
    acme_selfsigned site['hostname'] do
      crt "/etc/ssl/#{site['hostname']}.crt"
      key "/etc/ssl/#{site['hostname']}.key"
      not_if { site['hostname'].nil? }
    end if site['ssl_enabled']

    nginx_site site['name'] do
      template 'nginx-site.erb'
      variables(
        blocks: ns['blocks']
      )
      action :enable
      notifies :reload, 'service[nginx]', :immediately
    end

    # Request the real certificate!
    acme_certificate site['hostname'] do
      fullchain "/etc/ssl/#{site['hostname']}.crt"
      chain     "/etc/ssl/#{site['hostname']}-chain.crt"
      key       "/etc/ssl/#{site['hostname']}.key"
      wwwroot   site['wwwroot']
      owner node['nginx']['user']
      group node['nginx']['group']
      notifies :reload, 'service[nginx]'
    end if site['ssl_enabled']
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "#{node.name}_nginx data bag not found" do
    level :info
  end
end
