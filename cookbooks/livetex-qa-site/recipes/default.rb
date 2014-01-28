#
# Cookbook Name:: livetex-qa-site
# Recipe:: default
#
# Copyright (C) 2013 stx
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'livetex-qa-site::structure'
include_recipe 'livetex-qa-site::virtualenv'
include_recipe 'livetex-qa-site::gunicorn'
include_recipe 'livetex-qa-site::database'
include_recipe 'livetex-qa-site::nginx'
include_recipe 'livetex-qa-site::supervisord'
