#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

project_path = node['livetex-qa-site']['project_path']
directories = ['/', '/log']


if !File.directory?(project_path)
  directories.each do |dir|
    directory project_path + dir do
      owner 'vagrant'
      group 'vagrant'
      mode 00770
      recursive true
      action :create
    end
  end
end
