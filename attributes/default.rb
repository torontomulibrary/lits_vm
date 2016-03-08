default['lits_vm']['additional_packages'] = nil
default['lits_vm']['permit_root_login'] = 'no'
default['lits_vm']['components'] = []

# Vagrant
default['lits_vm']['vagrant_share'] = '/vagrant'

# MySQL Service default configuration
default['mysql']['service_name'] = 'default'
default['mysql']['bind_address'] = '127.0.0.1'
default['mysql']['version'] = '5.5'
default['mysql']['initial_root_password'] = 'a secure password'

default['php']['fpm_user']  = node['nginx']['user']
default['php']['fpm_group'] = node['nginx']['user']

# Disable default nginx site
default['nginx']['default_site_enabled'] = false
