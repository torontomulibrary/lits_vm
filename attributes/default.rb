default['lits_vm']['users']['manage_groups'] = []

default['lits_vm']['firewall']['allow_ports'] = {}

default['lits_vm']['configure_nginx_sites'] = true

default['lits_vm']['packages'] = %w(curl git)
default['lits_vm']['additional_packages'] = []

default['lits_vm']['enable_webtatic'] = false

# PHP stuff
default['php']['fpm_user']  = node['nginx']['user']
default['php']['fpm_group'] = node['nginx']['user']

# sudos
default['authorization']['sudo']['groups'] = ['sysadmin']

## Do not edit below!
default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['nginx']['default_site_enabled'] = false
