name             'lits_vm'
maintainer       'Patrick Fung'
maintainer_email 'patrick@makestuffdostuff.com'
license          'All rights reserved'
description      'Configures a base VM for installing applications'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.3'

depends 'sshd', '~> 2.0.0'
depends 'ssh-hardening', '~> 2.7.0'
depends 'selinux', '~> 2.1.1'

# Chef Sugar is a Gem & Chef Recipe that includes series of helpful sugar of
# the Chef core and other resources to make a cleaner, more lean recipe DSL,
# enforce DRY principles, and make writing Chef recipes an awesome experience!
# http://sethvargo.github.io/chef-sugar/
depends 'chef-sugar', '~> 5.0.0'

depends 'apt', '>= 0.0.0'
depends 'yum-epel', '>= 0.0.0'
depends 'yum-webtatic', '>=0.0.0'

# depends 'users', '~> 5.4.0'
depends 'sudo', '~> 5.4.4'

depends 'firewall', '~> 2.7.0' 

depends 'chef_nginx', '~> 6.2.0'
depends 'acme', '~> 4.0.0'

depends 'mysql', '~> 8.5.1'
depends 'yum-mysql-community', '~> 4.0.1'

# The database community cookbook is now deprecated, but there is nothing that
# replaces the functionality. The intention of the developers is to migrate the 
# LWRPs into the mysql community cookbook, but as of now that hasn't happened so
# we continue to use it.
depends 'database', '~> 6.1.1' 
depends 'mysql2_chef_gem', '~> 2.1.0'

depends 'php', '~> 6.1.1'

depends 'java', '~> 3.1.2'

# AtoM lists Elasticsearch version 1.7.x as a requirement.
# The elasticsearch community cookbook is written to support ES v2.x+
# By sheer luck v2.5.0 still works to install the version of ES we want
# but it probably won't work in the future
# https://supermarket.chef.io/cookbooks/elasticsearch/versions/2.5.0
depends 'elasticsearch', '~> 2.5.0'

depends 'nodejs', '~> 6.0.0'

depends 'tar', '~> 2.2.0'
