lits_vm CHANGELOG
==============

This file is used to list changes made in each version of the lits_vm cookbook.

0.3.3
-----
- Use ssh-hardening cookbook to configure secure sshd

0.3.2
- Use attribute "packages" rather than "additional_packages" to specifiy packages to be installed.

0.3.1
-----
- Added option to install PHP from Webtatic repository for EL machines
- Delegate responsibility of installing packages for PHP to the php community cookbook

0.3.0
-----
- Make the databag configuration more sane

0.2.0
-----
- Update the default recipe to always install firewall
- Remove the "install_component" attribute. Leave it up to the run_list to decide what to install.
- Use the community sshd cookbook recipe to secure ssh rather than providing our own template
- Improve nginx configuration: configurations stored in data bags, and dynamically generated
- Improve mysql configuration: configurations stored in data bags, and dynamically generated
- Improve php fpm configuration: configurations stored in data bags, and dynamically generated
- Drop support for Vagrant

0.1.0
-----
- Initial release of lits_vm

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
