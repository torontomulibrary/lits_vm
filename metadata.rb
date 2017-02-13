name             'lits_vm'
maintainer       'Patrick Fung'
maintainer_email 'patrick@makestuffdostuff.com'
license          'All rights reserved'
description      'Configures a base VM for installing applications'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.5'

depends 'sshd', '~> 1.3.0'
depends 'ssh-hardening', '~> 1.3.0'

# Chef Sugar is a Gem & Chef Recipe that includes series of helpful sugar of
# the Chef core and other resources to make a cleaner, more lean recipe DSL,
# enforce DRY principles, and make writing Chef recipes an awesome experience!
# http://sethvargo.github.io/chef-sugar/
depends 'chef-sugar', '~> 3.4.0'

depends 'apt', '>= 0.0.0'
depends 'yum-epel', '>= 0.0.0'
depends 'yum-webtatic', '>=0.0.0'

depends 'users', '~> 4.0.3'
depends 'sudo', '~> 3.1.0'

depends 'firewall', '~> 2.5.3'

depends 'chef_nginx', '~> 4.0.2'
depends 'acme', '~> 2.0.0'

depends 'mysql', '~> 6.1.2'
depends 'database', '~> 4.0.9'
depends 'mysql2_chef_gem', '~> 1.0.2'

depends 'php', '~> 2.1.1'

depends 'java', '~> 1.42.0'

# Don't use a more recen't version the elasticsearch cookbook. It's not
# confirmed to work with the version of Elasticsearch we are targeting (1.7.x)
# Refer to: https://github.com/elastic/cookbook-elasticsearch/tree/0.3.x
depends 'elasticsearch', '~> 0.3.14'

depends 'nodejs', '~> 3.0.0'

depends 'tar', '~> 0.7.0'
