
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

project_path = node['livetex-qa-site']['project_path']
deps = node['livetex-qa-site']['dependencies']


python_virtualenv project_path do
  owner 'vagrant'
  group 'vagrant'
  action :create
end


deps.each do |pack, ver|
  python_pip pack do
    virtualenv project_path
    version ver
    user 'vagrant'
    group 'vagrant'
    action :upgrade
  end
end
