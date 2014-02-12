name             'django-site'
maintainer       'stx'
maintainer_email 'splusminusx@gmail.com'
license          'All rights reserved'
description      'Installs/Configures Django site with Supervisord/PostgreSQL/NGINX/Gunicorn'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "database"
depends "postgresql"
depends "nginx"
depends "supervisord"
depends "python"
