name             'apache2-git-site'
maintainer       'Simon Detheridge'
maintainer_email 'simon@widgit.com'
license          'Apache v2.0'
description      'Sets up an apache vhost site backed by a git repo'
long_description 'Installs an apache virtual host website using git as a backend. The website is redeployed when files are merged into a specified branch.'
version          '0.2.1'

depends          'apache2'
depends          'git'

provides         'apache2-git-site::default'

supports         'debian'
supports         'ubuntu'

