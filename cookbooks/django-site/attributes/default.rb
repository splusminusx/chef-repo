default['django-site']['project_name'] = 'django-site'
default['django-site']['project_path'] = '/vagrant/projects/django-site'
default['django-site']['domain'] = 'django-site.local'
default['django-site']['dependencies'] = {
	'django' => '1.5.2',
	'south' => '0.8.2',
	'psycopg2' => '2.5.2'
}
default['django-site']['database_user'] = 'vagrant'
default['django-site']['database_password'] = 'vagrant'
default['django-site']['user'] = 'vagrant'
default['django-site']['group'] = 'vagrant'

default['django-site']['data_bag_name'] = 'django_sites'
default['django-site']['django_sites'] = ['django-site']