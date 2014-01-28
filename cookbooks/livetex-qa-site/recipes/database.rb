#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'


template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  cookbook "livetex-qa-site"
end


postgresql_connection_info = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password_raw']['postgres']
}


postgresql_database_user 'vagrant' do 
  connection postgresql_connection_info
  password 'vagrant'
  action :create
end


postgresql_database 'eco' do
  connection postgresql_connection_info
  action :create
end
