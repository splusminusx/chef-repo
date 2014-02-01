#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'


port = node['postgresql']['config']['port']
host = 'localhost'
project_database = 'eco'
project_user = 'vagrant'
project_password = 'vagrant'
project_name = node['livetex-qa-site']['project_name']
project_path = node['livetex-qa-site']['project_path']


template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  cookbook "livetex-qa-site"
end


postgresql_connection_info = {
  :host     => host,
  :port     => port,
  :username => 'postgres',
  :password => node['postgresql']['password_raw']['postgres']
}


postgresql_database_user project_user do 
  connection postgresql_connection_info
  password project_password
  action :create
end


postgresql_database project_database do
  connection postgresql_connection_info
  action :create
end


template "#{project_path}/#{project_name}/#{project_name}/local_settings.py" do
  source "local_settings.erb"
  mode 0660
  owner "vagrant"
  group "vagrant"
  variables({
    :project_database => project_database,
    :project_user => project_user,
    :project_password => project_password,
    :host => host,
    :port => port
  })
end
