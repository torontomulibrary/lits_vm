lits_vm CHANGELOG
==============

This file is used to list changes made in each version of the lits_vm cookbook.

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
