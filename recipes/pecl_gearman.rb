#
# Cookbook Name:: lits_vm
# Recipe:: pecl_gearman
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-sugar'

package 'libgearman'
package 'libgearman-devel'

# Clone pecl-gearman into temp dir
git "#{Chef::Config['file_cache_path']}/pecl-gearman" do
  repository 'https://github.com/wcgallego/pecl-gearman.git'
  revision 'gearman-2.0.5'
end

# Compile pecl-gearman extension from source
execute 'compile-pecl-gearman' do
  cwd "#{Chef::Config['file_cache_path']}/pecl-gearman"
  command 'phpize && ./configure && make && make install'
  creates "#{node['php']['ext_dir']}/gearman.so"
end

# Enable gearman php extension
template "#{node['php']['ext_conf_dir']}/gearman.ini" do
  source 'gearman.ini'
end
