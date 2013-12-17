# Cookbooks for App Servers

## Description

These cookbooks are configurations for Dev/Web/DB servers.
The developers and the operators uses Dev server as start of operations.

* 172.20.10.11 Dev server ( for development and operation )
 * script:initializer/setup.sh
    * git
    * group : staff
    * rbenv
    * ruby-buid
    * ruby 2.x
    * echo 'options single-request-reopen' >> /etc/resolv.conf
    * bundler
    * chef
 * role:dev_server
    * installed on sakura
        * postfix
    * role:base
        * recipe: yum::epel
        * recipe:initial_user
            * group : staff
            * user  : devuser
            * /etc/sudoers.d/devuser
            * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
        * recipe:openssh
        * recipe:simple_iptables
    * recipe:dev_server
        * install packages
            * perl-core
        * iptables for dev server in sakura
    * role:repository
        * recipe:gitolite
    * role:web
        * recipe:nginx (for development, sorry page, munin console)
        * recipe:php (for development)
    * role:monitoring_server
        * recipe:munin_wrapper::server
    * role:monitoring
        * recipe:munin_wrapper::client
 * TODO
    * mysql (for development)

* 172.20.10.12 Web server
 * role:web_server
    * installed on sakura
        * postfix
    * role:base
        * recipe: yum::epel
        * initial_user
            * group : staff
            * user  : devuser
            * /etc/sudoers.d/devuser
            * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
        * recipe:openssh
        * recipe:simple_iptables
    * recipe:web_server
        * install packages
            * perl-core
        * iptables for web server in sakura
        * autofs ( /mnt/share )
    * role:web
        * recipe:nginx
        * recipe:php
    * role:monitoring
        * recipe:munin_wrapper::client
 * TODO

* 172.20.10.13 DB server / Storage server
 * role:db_server
    * role:base
        * recipe: yum::epel
        * initial_user
            * group : staff
            * user  : devuser
            * /etc/sudoers.d/devuser
            * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
        * recipe:openssh
        * recipe:simple_iptables
    * recipe:nfs::server
    * recipe:db_server
        * install packages
            * perl-core
        * iptables for db server in sakura
        * nfs ( /exports )
    * role:monitoring
        * recipe:munin_wrapper::client
 * TODO
    * mysql

## Setup

### Files

<table>
  <thead>
    <tr>
      <th>file</th>
      <th>description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>id_rsa_devuser</td>
      <td>private key for devuser (OS user)</td>
    </tr>
    <tr>
      <td>id_rsa_devuser.pub</td>
      <td>public key for devuser (OS user)</td>
    </tr>
    <tr>
      <td>id_rsa_gitolite_admin</td>
      <td>private key for admin (gitolite user)</td>
    </tr>
    <tr>
      <td>id_rsa_gitolite_admin.pub</td>
      <td>public key for admin (gitolite user)</td>
    </tr>
  </tbody>
</table>

### Step

* Startup
 * (Case: vagrant) execute `vagrant up` in `"initializer"`, and login to dev as root.
 * (Case: not vagrant) login to dev as root, and execute `initializer/setup.sh`

```
You can `knife solo cook root@targethost` as root for the first time.
But this cookbooks revoke ssh login from root, you should use `knife solo cook devuser@targethost` as devuser from the second time.
```

* As root in Dev (From the second time, root -> devuser)
 * $ `mkdir ~/work`
 * $ `cd ~/work`
 * $ `git clone [app-server-cookbook]`
 * upload id_rsa_devuser to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/devuser/id_rsa
 * upload id_rsa_devuser.pub to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/devuser/id_rsa.pub
 * upload id_rsa_gitolite_admin.pub to ~/work/app-server-cookbook/site-cookbooks/**gitolite**/files/default/gitolite/admin.pub
 * **replace `htpasswd` in ~/work/app-server-cookbook/data_bags/users/munin.json**
    * You can generate password by `htpasswd -ns munin` (need apache)
 * $ `cd ~/work/app-server-cookbook`
 * $ `berks install --path cookbooks`
 * $ `knife solo cook root@localhost` # From the second time, root -> devuser
    * **WARN: You can no longer ssh login as root. Please use devuser.**
    * **WARN: You should try login as devuser before logout from current root session.**

* As devuser in Dev
 * targethost = 172.20.10.12, 172.20.10.13
    * $ `knife solo prepare root@targethost` # From the second time, root -> devuser
    * $ `knife solo cook root@targethost` # From the second time, root -> devuser
        * Enter the root password about 10 times.
        * If you created trusted user (e.g. devuser), you can skip entering password.

### checkout configuration repository for gitolite

 * `git clone gitolite@172.20.10.11:gitolite-admin`
     * use id_rsa_gitolite_admin.

### Windows (untested)

* Virtual Box
 * https://www.virtualbox.org/wiki/Downloads
* Vagrant
 * http://www.vagrantup.com/downloads.html
* Chef
 * http://www.getchef.com/chef/install/
* Ruby DevKit
 * http://rubyinstaller.org/downloads
    * `ruby dk.rb init`
    * `ruby dk.rb install`
* knife-solo
 * `gem install knife-solo --no-rdoc --no-ri`

## Note

* Security Issues
 * Enabled `PasswordAuthentication`, `RSAAuthentication` and `PubkeyAuthentication`.
 * devuser can sudo without password (with `NOPASSWD` option).

## Refs.

* http://www.slideshare.net/JulianDunn/beginner-chef-antipatterns
* http://www.creationline.com/lab/3080
* http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns/
* http://qiita.com/mokemokechicken/items/8369ff19453f73913f1e

## License

```
Copyright 2013 t_yamo@unknown-artifacts.info

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

