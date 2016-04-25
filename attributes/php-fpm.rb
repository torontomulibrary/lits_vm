default['lits_vm']['fpm_pool_config']['user'] = 'nginx'
default['lits_vm']['fpm_pool_config']['group'] = 'nginx'

default['lits_vm']['fpm_pool_config']['pm']['mode'] = 'ondemand'
default['lits_vm']['fpm_pool_config']['pm']['max_children'] = 30
default['lits_vm']['fpm_pool_config']['pm']['process_idle_timeout'] = '10s'
