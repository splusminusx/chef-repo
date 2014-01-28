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


python_pip 'gunicorn' do
  virtualenv project_path
  version '18.0'
  user "vagrant"
  group "vagrant"
  action :upgrade
end


template "#{project_path}/gunicorn_start" do
  source "gunicorn_start.erb"
  mode 0770
  owner "vagrant"
  group "vagrant"
  variables({
    :project_name => project_name,
    :django_dir => "#{project_path}/#{project_name}"
  })
end
