#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

project_name = node['livetex-qa-site']['project_name']
project_path = node['livetex-qa-site']['project_path']
domain = node['livetex-qa-site']['domain']


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


service 'nginx' do
  action :reload
end
