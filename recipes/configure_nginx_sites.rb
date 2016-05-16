#
# Cookbook Name:: lits_vm
# Recipe:: configure_nginx_sites
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

search("#{node.name}_nginx", '*:* AND NOT disable:true') do |nginx_site|
  if nginx_site['owner']
    root_dir = "/home/#{nginx_site['owner']}/public_html/#{nginx_site['id']}"

    directory "/home/#{nginx_site['owner']}/public_html" do
      owner nginx_site['owner']
      group nginx_site['owner']
    end

    directory root_dir do
      owner nginx_site['owner']
      group node['nginx']['group']
      mode '775'
    end
  end

  root_dir ||= nginx_site['root_dir'] || "#{node['nginx']['default_root']}/#{nginx_site['id']}"
  index ||= nginx_site['index'] || 'index.php index.html index.htm'
  access_log ||= nginx_site['access_log'] || "#{node['nginx']['log_dir']}/access.log"
  error_log ||= nginx_site['error_log'] || "#{node['nginx']['log_dir']}/error.log"

  site_server_config = [
    { name: 'root', value: root_dir },
    { name: 'index', value: index },
    { name: 'access_log', value: access_log },
    { name: 'error_log', value: error_log }
  ]

  # remove items with empty values
  site_server_config.select! do |server_config|
    !server_config[:value].empty?
  end

  site_server_config += nginx_site['server_config'] unless nginx_site['server_config'].nil?

  if rhel?
    php_fpm_socket = "unix:/var/run/php-fpm.#{nginx_site['fpm_pool']}.sock" unless nginx_site['fpm_pool'].nil?
  elsif debian?
    php_fpm_socket = "unix:/var/run/php5-fpm.#{nginx_site['fpm_pool']}.sock" unless nginx_site['fpm_pool'].nil?
  end

  virtual_host nginx_site['id'] do
    php_fpm_socket php_fpm_socket
    server_name nginx_site['server_name']
    server_config site_server_config
    location_blocks nginx_site['location_blocks']
    action [:create, :disable, :enable]
  end
end
