default['lits_vm']['users'] = []
default['lits_vm']['user_groups'] = []

default['lits_vm']['firewall']['allow_ports'] = {}

default['lits_vm']['packages'] = %w(curl git)

default['lits_vm']['scls'] = nil
default['lits_vm']['enable_webtatic'] = false
default['lits_vm']['install_nodejs'] = false

## Do not edit below!
default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['nginx']['default_site_enabled'] = false

# when this is set to false, knife zero doesn't work!
default['ssh']['allow_tcp_forwarding'] = true
