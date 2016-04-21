lits_vm Cookbook
=============
This cookbook will configures a base VM for installing applications.

Attributes
----------

#### lits_vm::default
* `node['lits_vm']['additional_packages']` - Additional packges to install using the default package manager, default: `nil`
* `node['lits_vm']['permit_root_login']` - Whether or not to allow root user login, default: `no`
* `node['lits_vm']['components']` - Components to install. See the recipes folder for available components, default: `[]`

Usage
-----

#### lits_vm::default

Just include `lits_vm` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[lits_vm]"
  ]
}
```

Recipes
-------

#### install_mysql.rb

This recipe installs a MySQL instance, and will look into the `node['mysql']['databases']` for instructions on how to configure databases.

```json
{
  "mysql" : {
    "service_name": "default",
    "initial_root_password": "a secure password",
    "databases" : {
      "MY_DATABASE" : {
        "user" : "my_database_user",
        "password" : "a secure password"
      }
    }
  }
}
```

#### install_nginx.rb

This recipe installs nginx, and will look into the `node['nginx']['sites_enabled']` array to enable nginx sites.

*Note*: The cookbook looks for a template in this cookbook's template folder named `SITE_NAME.nginx.erb`

```json
{ 
  "nginx" : {
    "sites_enabled" : {
      "SITE_NAME" : {
        "root_directory" : "mysite",
        "server_name" : "my.domain.com"
      }
    }
  }
}
```

License and Authors
-------------------
* Patrick Fung (<patrick@makestuffdostuff.com>)
