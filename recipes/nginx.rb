#
# Cookbook Name:: lits_vm
# Recipe:: nginx
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Generate a self-signed certificate because nginx breaks
# when SSL is asked for with missing certificates
include_recipe 'acme'
begin
  search("#{node.name}_bags", 'bag_type:ssl_config') do |ssl|
    acme_selfsigned ssl.hostname do
      crt "/etc/ssl/#{ssl}.crt"
      key "/etc/ssl/#{ssl}.key"
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "No SSL configuration databags for #{node.name} found" do
    level :info
  end
end

# Configure nginx sites from data bags
include_recipe 'chef_nginx'
directory node['nginx']['default_root'] do
  recursive true
end

begin
  search("#{node.name}_bags", 'bag_type:nginx_site') do |ns|
    nginx_site ns['name'] do
      template 'nginx-site.erb'
      variables(
        blocks: ns['blocks']
      )
      action :enable
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "#{node.name}_nginx data bag not found" do
    level :info
  end
end

# Request the real certificate
include_recipe 'acme'
begin
  search("#{node.name}_bags", 'bag_type:ssl_config') do |ssl|
    acme_certificate ssl.hostname do
      fullchain "/etc/ssl/#{ssl.hostname}.crt"
      chain     "/etc/ssl/#{ssl.hostname}-chain.crt"
      key       "/etc/ssl/#{ssl.hostname}.key"
      wwwroot   node['nginx']['default_root']
      notifies  :reload, 'service[nginx]'
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log "No SSL configuration databags for #{node.name} found" do
    level :info
  end
end
