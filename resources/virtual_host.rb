#
# Cookbook Name:: lits_vm
# Resource:: virtual_host
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

default_action :create
actions :create, :enable, :disable

attribute :vhost_name, kind_of: String, name_attribute: true
attribute :listen, kind_of: [String, Integer], default: 80
attribute :server_name, kind_of: String, default: nil
attribute :php_fpm_socket, kind_of: String, default: nil
attribute :server_config, kind_of: Array, default: []
attribute :location_blocks, kind_of: Array, default: []

provides :virtual_host
