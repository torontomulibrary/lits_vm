default['lits_vm']['users']['manage_groups'] = []

default['lits_vm']['firewall']['allow_ports'] = {}

default['lits_vm']['packages'] = %w(curl git)

default['lits_vm']['enable_webtatic'] = false

# sudos
default['authorization']['sudo']['groups'] = ['sysadmin']

## Do not edit below!
default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['nginx']['default_site_enabled'] = false

# when this is set to false, knife zero doesn't work!
default['ssh']['allow_tcp_forwarding']    = false   # sshd
