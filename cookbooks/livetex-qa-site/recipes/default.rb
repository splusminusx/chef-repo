#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'
include_recipe 'supervisord::default'


template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  cookbook "livetex-qa-site"
end


postgresql_connection_info = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password_raw']['postgres']
}


virtualenv_name = "#{node['livetex-qa-site']['virtualenv_dir']}/#{node['livetex-qa-site']['project_name']}"


postgresql_database_user 'vagrant' do 
  connection postgresql_connection_info
  password 'vagrant'
  action :create
end


postgresql_database 'eco' do
  connection postgresql_connection_info
  action :create
end


if !File.directory?("#{node['livetex-qa-site']['www_dir']}")
  directory "#{node['livetex-qa-site']['www_dir']}" do
    owner 'vagrant'
    group 'vagrant'
    mode 00770
    action :create
  end
end


python_virtualenv virtualenv_name do
  owner 'vagrant'
  group 'vagrant'
  action :create
end


python_pip 'django' do
  virtualenv virtualenv_name
  version '1.5.2'
  user 'vagrant'
  group 'vagrant'
  action :upgrade
end


python_pip 'south' do  
  virtualenv virtualenv_name
  version '0.8.2'
  user 'vagrant'
  group 'vagrant'
  action :upgrade
end


python_pip 'gunicorn' do
  virtualenv virtualenv_name
  version '18.0'
  user "vagrant"
  group "vagrant"
  action :upgrade
end


if !File.directory?("#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}")
  directory "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}" do
    owner 'vagrant'
    group 'vagrant'
    mode 00770
    action :create
  end
end


template "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/gunicorn_start" do
  source "gunicorn_start.erb"
  mode 0770
  owner "vagrant"
  group "vagrant"
  variables({
    :project_name => "#{node['livetex-qa-site']['project_name']}",
    :django_dir => "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/#{node['livetex-qa-site']['project_name']}"
  })
end


template "/etc/nginx/sites-available/#{node['livetex-qa-site']['project_name']}" do
  source "nginx_site.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :project_name => "#{node['livetex-qa-site']['project_name']}",
    :django_dir => "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/#{node['livetex-qa-site']['project_name']}",
    :log_dir => "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/log",
    :domain => "#{node['livetex-qa-site']['domain']}"
  })
end


link "/etc/nginx/sites-enabled/#{node['livetex-qa-site']['project_name']}" do
  to "/etc/nginx/sites-available/#{node['livetex-qa-site']['project_name']}"
end


if !File.directory?("#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/log")
  directory "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/log" do
    owner 'vagrant'
    group 'vagrant'
    mode 00770
    action :create
  end
end


supervisord_program "#{node['livetex-qa-site']['project_name']}" do
  command "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/gunicorn_start"
  user 'root'
  stdout_logfile "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/log/gunicorn_stdout.log"
  stderr_logfile "#{node['livetex-qa-site']['www_dir']}/#{node['livetex-qa-site']['project_name']}/log/gunicorn_stdout.log"
end

