default['lits_vm']['additional_packages'] = nil

# TODO: include clase that forces this if nginx is enabled??
default['lits_vm']['allow_web_traffic'] = false

default['lits_vm']['install_mysql'] = false
default['lits_vm']['install_nginx'] = false

default['lits_vm']['install_nodejs'] = false
default['lits_vm']['npm_modules'] = nil

default['lits_vm']['install_elasticsearch'] = false
# TODO: include clase that forces java install if elasticsearch is enabled
default['lits_vm']['install_java'] = false

# PHP
default['lits_vm']['install_php'] = false
default['lits_vm']['php_packages'] = []

# MySQL Service default configuration
default['mysql']['service_name'] = 'default'
default['mysql']['bind_address'] = '127.0.0.1'
default['mysql']['version'] = '5.5'
default['mysql']['initial_root_password'] = 'a secure password'

default['php']['fpm_user']      = 'nginx'
default['php']['fpm_group']     = 'nginx'
