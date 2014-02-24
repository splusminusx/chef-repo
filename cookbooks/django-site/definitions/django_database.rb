#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#


define :django_database, :host => '', :port => '', :database_user => '', :database_password => '', :project_name => '', :project_path => '', :user => '', :group => '' do

  # Includes.
  include_recipe 'postgresql::server'
  include_recipe 'postgresql::ruby'


  # Params.
  port = params[:port]
  host = params[:host]
  database = params[:name]
  database_user = params[:database_user]
  database_password = params[:database_password]
  project_user = params[:user]
  project_group = params[:group]
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
  postgresql_database_user database_user do 
    connection postgresql_connection_info
    password database_password
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
    owner project_user
    group project_group
    variables({
      :database => database,
      :user => database_user,
      :password => database_password,
      :host => host,
      :port => port
    })
  end
end
