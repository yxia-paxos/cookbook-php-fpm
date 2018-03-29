#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php-fpm
# Recipe:: package
#
# Copyright 2011-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'php-fpm::repository' unless node['php-fpm']['skip_repository_install']

php_fpm_package_name = if node['php-fpm']['package_name'].nil?
                         if platform_family?('rhel', 'fedora')
                           'php56-fpm'
                         elsif platform?('ubuntu') && node['platform_version'].to_f >= 16.04
                           'php7.0-fpm'
                         else
                           'php56-fpm'
                         end
                       else
                         node['php-fpm']['package_name']
                       end

package php_fpm_package_name do
  action node['php-fpm']['installation_action']
  version node['php-fpm']['version'] if node['php-fpm']['version']
end

php_fpm_service_name = if node['php-fpm']['service_name'].nil?
                         php_fpm_package_name
                       else
                         node['php-fpm']['service_name']
                       end

service_provider = nil
# this is actually already done in chef, but is kept here for older chef releases
if platform?('ubuntu') && node['platform_version'].to_f.between?(13.10, 14.10)
  service_provider = ::Chef::Provider::Service::Upstart
end

directory node['php-fpm']['log_dir']

service 'php-fpm' do
  provider service_provider if service_provider
  service_name php_fpm_service_name
  supports start: true, stop: true, restart: true, reload: true
  action [:enable, :start]
end
