name             'lits_vm'
maintainer       'Patrick Fung'
maintainer_email 'patrick@makestuffdostuff.com'
license          'All rights reserved'
description      'Configures a base VM for installing applications'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

depends 'sshd', '~> 1.1.3'

# Chef Sugar is a Gem & Chef Recipe that includes series of helpful sugar of
# the Chef core and other resources to make a cleaner, more lean recipe DSL,
# enforce DRY principles, and make writing Chef recipes an awesome experience!
# http://sethvargo.github.io/chef-sugar/
depends 'chef-sugar', '~> 3.3.0'

depends 'apt', '~> 2.2' # Version constraint required by nginx cookbook
depends 'yum-epel', '~> 0.6.5'

depends 'users', '~> 2'
depends 'sudo', '~> 2.9.0'

depends 'firewall', '~> 2.4.0'

depends 'nginx', '~> 2.7.6'

depends 'mysql', '~> 6.1.2'
depends 'database', '~> 4.0.9'
depends 'mysql2_chef_gem', '~> 1.0.2'

depends 'php', '~> 1.8.0'

depends 'java', '~> 1.39.0'

# Don't use a more recen't version the elasticsearch cookbook. It's not
# confirmed to work with the version of Elasticsearch we are targeting (1.7.x)
# Refer to: https://github.com/elastic/cookbook-elasticsearch/tree/0.3.x
depends 'elasticsearch', '~> 0.3.13'

depends 'nodejs', '~> 2.4.4'

depends 'tar', '~> 0.7.0'
