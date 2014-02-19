#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#


django_database node['django-site']['project_name'] do 
	user node['django-site']['database_user']
	password node['django-site']['database_password']
	project_name node['django-site']['project_name']
	project_path node['django-site']['project_path']
end


django_site node['django-site']['project_name'] do
	project_path node['django-site']['project_path']
	domain node['django-site']['domain']
	dependencies node['django-site']['dependencies']
	user node['django-site']['user']
	group node['django-site']['group']
end