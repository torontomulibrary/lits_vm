#
# Cookbook Name:: lits_vm
# Recipe:: nginx
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef_nginx'

# Configure nginx sites from data bags
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
