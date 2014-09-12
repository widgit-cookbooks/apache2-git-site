# apache2-git-site-cookbook

This cookbook configures a git-backed site on an apache2 vhost, allowing easy
deployments without having to use ftp or capistrano.

A site can be redeployed by merging changes into a specified branch (default:
the node's environment name)

The git repository will be re-synced every chef run, and can be configured
from node attributes. Multiple sites can be created by listing additional sites
in the attribute hash. A new user will be created for each site, and by default
the files will be owned by this user, and the apache group.

## Suggestions

Use the [s3fs cookbook](https://supermarket.getchef.com/cookbooks/s3fs) to
mount persistent storage for use between your web instances, if necessary.

## Supported Platforms

Ubuntu, possibly other unices. (Untested)

## Dependencies

Cookbooks:
- git
- apache2

Recipes included
- git::default
- apache2::default

## Attributes

<table>
  <tr>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites-path']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Root directory to contain cloned sites</td>
    <td colspan="3">- *node/var/www</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites']*</td>
  </tr>
  <tr>
    <td>Hash</td>
    <td>Hash of site definitions</td>
    <td colspan="3">- *nodeEmpty hash</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites']{hash_key}*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Site ID</td>
    <td>None</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites']{hash_value}*</td>
  </tr>
  <tr>
    <td>Hash</td>
    <td>Hash of site parameters</td>
    <td>None</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['documentroot']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Document root relative to the root of the git repostitory</td>
    <td>htdocs</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['repository']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>URL for the git repository to be cloned</td>
    <td>None (required)</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['branch']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Git branch to be checked out</td>
    <td>node['environment']</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['site-user']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>User that the checked-out files will be owned by</td>
    <td>www-#{site-id}</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['site-group']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Group that the checked-out files will be owned by. Must already exist, and apache user should be a member.</td>
    <td>node['apache']['group']</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['servername']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Vhost server name</td>
    <td>None (required)</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['serveradmin']*</td>
  </tr>
  <tr>
    <td>String</td>
    <td>Server admin</td>
    <td>webmaster@#{['apache2-git-site']['sites'][site_id]['servername']}</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['serveraliases']*</td>
  </tr>
  <tr>
    <td>String Array</td>
    <td>Vhost server aliases</td>
    <td>Empty array</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['default-options']*</td>
  </tr>
  <tr>
    <td>String Array</td>
    <td>Default apache options for documentroot directory</td>
    <td>['FollowSymLinks', 'MultiViews', 'ExecCgi']</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['aliases']*</td>
  </tr>
  <tr>
    <td>Hash Array {"path": "root"}</td>
    <td>An array of hashes that define aliases, where 'path' is the alias path, and 'root' is the alias root relative to the checkout directory</td>
    <td>Empty array</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['extra-config']*</td>
  </tr>
  <tr>
    <td>String Array</td>
    <td>An array of additional configuration lines to be added to the apache virtual host configuration file. For example, adding rewrite rules or specifying a custom log.</td>
    <td>Empty array</td>
  </tr>
  <tr>
    <td colspan="3">- *node['apache2-git-site']['sites'][site_id]['sync-notify-commands']*</td>
  </tr>
  <tr>
    <td>String Array</td>
    <td>Specifies a sequence of commands to be executed from inside the git root directory (as the site user) when changes are pulled from the git repository</td>
    <td>Empty array</td>
  </tr>
</table>

## Usage

### apache2-git-site::default

Include `apache2-git-site` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[apache2-git-site::default]"
  ]
}
```

Configure your sites in your node's attributes:
```json
{
  "apache2-git-site": {
    "my_awesome_site": {
      "repository": "https://github.com/example/awesome.git",
      "servername": "www.example.org"
    }
  }
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

License:: Apache v2.0
Author:: Simon Detheridge (<simon@widgit.com>)
