#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

define :django_site, :project_path => '', :domain => '', :dependencies => '', :user => '', :group => '' do 
	
	# Includes.
	include_recipe "python::default"
	include_recipe 'supervisord::default'


	# Params.
  project_name = params[:name]
  project_path = params[:project_path]
  project_user = params[:user]
  project_group = params[:group]
  domain = params[:domain]
  dependencies = params[:dependencies]

  
  # Creates project structure.
  directories = ["/", "/log", "/#{project_name}", "/#{project_name}/#{project_name}"]

  if !File.directory?(project_path)
    directories.each do |dir|
      directory project_path + dir do
	  	  owner project_user
		    group project_group
	    	mode 00770
	    	recursive true
	    	action :create
	  	end
		end
  end


  # Creates virtuelenv.
  python_virtualenv project_path do
	  owner project_user
	  group project_group
	  action :create
	end


	# Installs dependencies.
	dependencies.each do |pack, ver|
	  python_pip pack do
	    virtualenv project_path
	    version ver
	    user project_user
	    group project_group
	    action :upgrade
	  end
	end


	# Installs gunicorn.
	python_pip 'gunicorn' do
	  virtualenv project_path
	  version '18.0'
	  user project_user
	  group project_group
	  action :upgrade
	end


	# Creates gunicorn start scripts.
	template "#{project_path}/gunicorn_start" do
	  source "gunicorn_start.erb"
	  mode 0770
	  owner project_user
	  group project_group
	  variables({
	    :project_name => project_name,
	    :django_dir => "#{project_path}/#{project_name}",
	    :user => project_user,
	    :group => project_group
	  })
	end

	# Configures supervisord.
	supervisord_program "#{project_name}" do
	  command "#{project_path}/gunicorn_start"
	  user 'root'
	  stdout_logfile "#{project_path}/log/gunicorn_stdout.log"
	  stderr_logfile "#{project_path}/log/gunicorn_stderr.log"
	end


	# Creates nginx site config.
	template "/etc/nginx/sites-available/#{project_name}" do
	  source "nginx_site.erb"
	  mode 0644
	  owner "root"
	  group "root"
	  variables({
	    :project_name => project_name,
	    :django_dir => "#{project_path}/#{project_name}",
	    :log_dir => "#{project_path}/log",
	    :domain => "#{domain}"
	  })
	end

	link "/etc/nginx/sites-enabled/#{project_name}" do
	  to "/etc/nginx/sites-available/#{project_name}"
	end


	# Restart nginx.
	service 'nginx' do
	  action :reload
	end

end
