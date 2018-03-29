case node['platform_family']
when 'rhel', 'fedora'
  user = 'nginx'
  group = 'nginx'
  conf_dir = '/etc/php-5.6.d'
  pool_conf_dir = '/etc/php-fpm-5.6.d'
  conf_file = '/etc/php-fpm-5.6.conf'
  error_log = '/var/log/php-fpm/error.log'
  pid = '/var/run/php-fpm/php-fpm-5.6.pid'
else
  user = 'www-data'
  group = 'www-data'
  if platform?('ubuntu') && node['platform_version'].to_f >= 16.04
    php_conf_dir = '/etc/php/7.0'
    php_fpm_name = 'php7.0-fpm'
  else
    php_conf_dir = '/etc/php5'
    php_fpm_name = 'php-fpm-5.6'
  end
  conf_dir = "#{php_conf_dir}/fpm/conf.d"
  pool_conf_dir = "#{php_conf_dir}/fpm/pool.d"
  conf_file = "#{php_conf_dir}/fpm/php-fpm.conf"
  error_log = "/var/log/#{php_fpm_name}.log"
  pid = "/var/run/#{php_fpm_name}.pid"
end

default['php-fpm']['user'] = user
default['php-fpm']['group'] = group
default['php-fpm']['conf_dir'] = conf_dir
default['php-fpm']['pool_conf_dir'] = pool_conf_dir
default['php-fpm']['conf_file'] = conf_file
default['php-fpm']['pid'] = pid
default['php-fpm']['log_dir'] = '/var/log/php-fpm'
default['php-fpm']['error_log'] = error_log
default['php-fpm']['log_level'] = 'notice'
default['php-fpm']['emergency_restart_threshold'] = 0
default['php-fpm']['emergency_restart_interval'] = 0
default['php-fpm']['process_control_timeout'] = 0
default['php-fpm']['process_manager'] = 'ondemand'
default['php-fpm']['max_children'] = 50
default['php-fpm']['start_servers'] = 5
default['php-fpm']['min_spare_servers'] = 5
default['php-fpm']['max_spare_servers'] = 35
default['php-fpm']['max_requests'] = 0
default['php-fpm']['request_terminate_timeout'] = 0
default['php-fpm']['catch_workers_output'] = 'no'
default['php-fpm']['security_limit_extensions'] = '.php'
default['php-fpm']['listen_mode'] = '0660'
default['php-fpm']['listen'] = '/var/run/php-fpm-%{pool_name}.sock'

default['php-fpm']['package_name'] = 'php56-fpm'
default['php-fpm']['service_name'] = 'php-fpm-5.6'

default['php-fpm']['pools'] = {
  'www' => {
    enable: true,
  },
}

default['php-fpm']['skip_repository_install'] = false
default['php-fpm']['installation_action'] = :install
default['php-fpm']['version'] = nil

case node['platform_family']
when 'rhel'
  default['php-fpm']['yum_url'] = 'http://rpms.famillecollet.com/enterprise/7/remi/$basearch/'
  default['php-fpm']['yum_mirrorlist'] = 'http://rpms.famillecollet.com/enterprise/7/remi/mirror'
when 'fedora'
  default['php-fpm']['skip_repository_install'] = true
end

default['php-fpm']['dotdeb_repository']['uri'] = 'http://packages.dotdeb.org'
default['php-fpm']['dotdeb_repository']['key'] = 'http://www.dotdeb.org/dotdeb.gpg'
default['php-fpm']['dotdeb-php53_repository']['uri'] = 'http://php53.dotdeb.org'
