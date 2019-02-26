#
# Cookbook Name:: lits_vm
# Recipe:: enable_services
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node['lits_vm']['services'].each do |service_name, start_service|
  service service_name do
    action :enable
  end

  if start_service
    service service_name do
      action :start
    end
  end
end
