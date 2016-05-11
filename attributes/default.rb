default['lits_vm']['users']['manage_groups'] = []

default['lits_vm']['firewall']['allow_ports'] = {}

default['lits_vm']['configure_nginx_sites'] = true

default['lits_vm']['additional_packages'] = []

# Vagrant
default['lits_vm']['vagrant_share'] = '/vagrant'

# PHP stuff
default['lits_vm']['php_extension_packages'] = []

default['php']['fpm_user']  = node['nginx']['user']
default['php']['fpm_group'] = node['nginx']['user']

# sudos
default['authorization']['sudo']['groups'] = ['sysadmin']

## Do not edit below!
default['firewall']['allow_ssh'] = true
default['nginx']['default_site_enabled'] = false
