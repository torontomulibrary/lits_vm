#
# Cookbook Name:: lits_vm
# Recipe:: pecl_apcu
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-sugar'

pecls = ['apcu', 'apcu_bc']

pecls.each do |pecl|
  php_pear pecl do
    action :install
    binary "pecl"
  end
end

template "#{node['php']['ext_conf_dir']}/apcu.ini" do
  source 'extension.ini.erb'
  cookbook 'lits_vm'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    name: 'apc',
    extensions: [
      'apcu.so', 
      'apc.so'
    ],
    directives: {
      'enabled' => '1',
      'shm_segments' => '1',
      'shm_size' => '64M',
      'entries_hint' => '4096',
      'ttl' => '7200',
      'use_request_time' => '1',
      'gc_ttl' => '3600',
      'smart' => '0',
      'slam_defense' => '1',
      'serializer' => "'default'",
      'enable_cli' => '0',
      'rfc1867' => '0',
      'rfc1867_prefix' => 'upload_',
      'rfc1867_name' => 'APC_UPLOAD_PROGRESS',
      'rfc1867_freq' => '0',
      'rfc1867_ttl' => '3600',
      'coredump_unmap' => '0'
    }
  )
end