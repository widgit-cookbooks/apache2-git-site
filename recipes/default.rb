#
# Cookbook Name:: apache2-git-site
# Recipe:: default
#
# Copyright (C) 2014 Simon Detheridge
#
# License:: Apache v2.0
#

include_recipe 'apache2'
include_recipe 'git'

sites_path = node['apache2-git-site']['sites-path'] || '/var/www'

directory sites_path do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end

# Create configuration for each site defined in the node attributes

node['apache2-git-site']['sites'].each_pair do |site_id, config|

  clone_path = File.join(sites_path, site_id)
  document_root = File.join(clone_path, (config['documentroot'] || 'htdocs'))
  site_user = config['site-user'] || "www-#{site_id}"
  site_group = config['site-group'] || node['apache']['group']

  # create the site user

  user site_user do
    home clone_path
    group site_group
    shell '/bin/false'
  end

  # create a new execute command for each notification command provided

  if config['sync-notify-commands'] && config['sync-notify-commands'].count > 0
    config['sync-notify-commands'].each_index do |index|
      execute "apache2-git-site-#{site_id}-sync-#{index}" do
        user site_user
        command config['sync-notify-commands'][index]
        cwd clone_path
        action :nothing
      end
    end
  end

  # create site directory with correct owner

  directory clone_path do
    user site_user
    group site_group
    mode '0750'
  end

  # configure git

  git clone_path do
    repository config['repository']
    user site_user
    group site_group
    revision config['branch'] || node.chef_environment
    action :sync

    # run the defined notify commands on successful sync

    if config['sync-notify-commands'] && config['sync-notify-commands'].count > 0
      config['sync-notify-commands'].each_index do |index|
        notifies :run, "execute[apache2-git-site-#{site_id}-sync-#{index}]", :immediately
      end
    end
  end

  # add vitrual host config file

  template File.join(node['apache']['conf_dir'], 'sites-available', "#{site_id}.conf") do
    source 'vhost.erb'
    owner 'root'
    group 'root'
    mode '0644'

    variables({
      :serveradmin => config['serveradmin'] || "webmaster@#{config['servername']}",
      :servername => config['servername'],
      :server_aliases => config['serveraliases'] || [],
      :documentroot => document_root,
      :options => config['default-options'] || ['FollowSymLinks', 'MultiViews', 'ExecCgi'],
      :aliases => config['aliases'] || {},
      :extra_config => config['extra-config'] || []
    })

    notifies :reload, 'service[apache2]', :delayed
  end

  # enable virtual host

  apache_site site_id do
    notifies :reload, 'service[apache2]', :delayed
  end
end

