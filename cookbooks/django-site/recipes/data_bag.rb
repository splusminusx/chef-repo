#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2014 stx
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'
include_recipe 'supervisord'


sites = node['django-site']['django_sites']

sites.each do |site|

	opts = data_bag_item(node['django-site']['data_bag_name'], site)

	django_site opts['project_name'] do
		project_path opts['project_path']
		domain opts['domain']
		dependencies opts['dependencies']
		user opts['user']
		group opts['group']
	end

	django_database opts['project_name'] do 
		user opts['database_user']
		password opts['database_password']
		project_name opts['project_name']
		project_path opts['project_path']
		host 'localhost'
		port 5432
	end

end
