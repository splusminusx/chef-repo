#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#


define :django_database, :host => '', :port => '', :user => '', :password => '', :project_name => '', :project_path => '' do

  # Includes.
  include_recipe 'postgresql::server'
  include_recipe 'postgresql::ruby'


  # Params.
  port = params[:port]
  host = params[:host]
  database = params[:name]
  user = params[:user]
  password = params[:password]
  project_name = params[:project_name]
  project_path = params[:project_path]


  # Update host access.
  template "#{node[:postgresql][:dir]}/pg_hba.conf" do
    cookbook "django-site"
  end


  # Postgres connection info.
  postgresql_connection_info = {
    :host     => host,
    :port     => port,
    :username => 'postgres',
    :password => node['postgresql']['password_raw']['postgres']
  }


  # Creates db user.
  postgresql_database_user user do 
    connection postgresql_connection_info
    password password
    action :create
  end


  # Creates database.
  postgresql_database database do
    connection postgresql_connection_info
    action :create
  end


  # Creates django database config.
  template "#{project_path}/#{project_name}/local_settings.py" do
    source "local_settings.erb"
    mode 0660
    owner "vagrant"
    group "vagrant"
    variables({
      :database => database,
      :user => user,
      :password => password,
      :host => host,
      :port => port
    })
  end
end
