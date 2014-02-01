#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'supervisord::default'


project_name = node['livetex-qa-site']['project_name']
project_path = node['livetex-qa-site']['project_path']


supervisord_program "#{project_name}" do
  command "#{project_path}/gunicorn_start"
  user 'root'
  stdout_logfile "#{project_path}/log/gunicorn_stdout.log"
  stderr_logfile "#{project_path}/log/gunicorn_stderr.log"
end
