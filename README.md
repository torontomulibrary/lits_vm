# lits_vm Cookbook
=============
This cookbook configures a server to install applications on. Currently only tested on CentOS 7.x, but should work on RHEL 7.x as well.

## Requirements
### Platforms
- CentOS 7.x

### Chef
- Chef 12.1+

### Cookbooks
- apt
- chef_nginx
- chef-sugar
- elasticsearch
- firewall
- java
- nodejs
- php
- ssh-hardening
- sshd
- sudo
- tar
- users
- yum-epel
- yum-webtatic
- mysql (~> 6.1.2)
- database (~> 4.0.9)
- mysql2_chef_gem (~> 1.0.2)

## Attributes
* `node['lits_vm']['packages']` - Packages that the cookbook will install using the default package manager, default `[curl, git]`
* `node['lits_vm']['enable_webtatic']` - Enables the Webtatic repository on EL systems (for recent versions of PHP), default `false`
* `node['lits_vm']['firewall']['allow_ports']` - Defines which ports are open on the firewall, default `{}`

## Resource/Provider
None.

## Recipes
### default
Include the default recipe in a run list. The default recipe does the following:
* Configures the ssh daemon
* Configures users and superusers using data bags (See https://supermarket.chef.io/cookbooks/users)
* Configures firewall
* Enables repositories if needed
* Installs specified packages
* Installs Node.js (TODO: make this optional and disabled by default)

### elasticsearch
This recipe installs elasticsearch (requires Java)

### ffmpeg
This recipe installs ffmpeg

### java
This recipe installs Java

### mysql
This recipe installs and configures MySQL databases using data bags

#### Data Bag Definition
A sample MySQL object in a data bag would look like:
```json
{
  "bag_type" : "mysql_service",
  "id" : "mysql_service_default",
  "name" : "default",
  "bind_address" : "127.0.0.1",
  "version" : "5.5",
  "initial_root_password" : "a super secure password",
  "databases" : [
    { "name" : "default" }
  ],
  "users" : [
    { 
      "username" : "mysql_user", 
      "password" : "a super secure password",
      "databases" : ["default"]
    }
  ]
}
```

### nginx
This recipe installs and configures Nginx using data bags
```json
{
  "bag_type" : "nginx_site",
  "id" : "nginx_site_blank",
  "name" : "blank",
  "blocks" : {
    "server" : [
      {
        "config" : [
          { "directive" : "listen", "value" : "80 default" },
          { "directive" : "server_name", "value" : "_" },
          { "directive" : "return", "value" : "444" }
        ]
      }
    ]
  } 
}
```

### php
This recipe installs and configures PHP and PHP-FPM using data bags
```json
{
  "bag_type" : "fpm_pool",
  "id" : "fpm_pool_default",
  "name" : "default_pool",
  "listen": "/var/run/php-fpm.default_pool.sock",
  "process_manager": "ondemand",
  "max_children": 10,
  "additional_config": {
    "env[PATH]": "/usr/local/bin:/usr/bin:/bin",
    "php_admin_value[date.timezone]": "\"America/Toronto\"",
    "php_value[pdo_mysql.default_socket]": "/var/run/mysql-default/mysqld.sock"
  }  
}
```

## Usage
Just include the `lits_vm` recipe at the beginning of your run list.

#### Role example:
```json
{
  "name": "my_server",
  "description": "Sets up my server",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "run_list": [
    "recipe[lits_vm]"
  ]
}
```

## License and Authors
* Patrick Fung (<patrick@makestuffdostuff.com>)
