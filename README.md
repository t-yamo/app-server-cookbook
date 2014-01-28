# Cookbooks for App Servers

## Description

These cookbooks are configurations for Dev/Web/DB servers.
The developers and the operators uses Dev server as start of operations.

Target environment is CentOS 6 (Vagrant or Sakura VPS).

* 172.20.10.11 dev01 - Dev server ( for development and operation )
 * script:initializer/setup.sh
    * git
    * group : staff
    * rbenv
    * ruby-buid
    * ruby 2.x
    * echo 'options single-request-reopen' >> /etc/resolv.conf
    * bundler
    * chef
    * knife-solo
    * berkshelf
    * knife-solo_data_bag
 * role:dev_server
    * installed on sakura
        * postfix
    * role:base
        * recipe: yum::remi
        * recipe: yum::epel
        * recipe:initial_users
            * group : staff
            * user  : devuser
            * /etc/sudoers.d/devuser
            * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
            * ~devuser/backup,shell
        * recipe:openssh
        * recipe:simple_iptables
    * recipe:dev_server
        * install packages
            * perl-core
            * nfs-utils
        * hosts
        * iptables for dev server in sakura
        * cron for backup_dev
    * role:repository
        * recipe:gitolite
    * role:web
        * recipe:nginx (for development, sorry page, munin console)
        * recipe:mysql::client (for development)
        * recipe:php (for development)
        * recipe:php::module_mysql
        * recipe:logrotate::nginx
    * role:db
        * recipe:mysql_wrapper::server (for development)
    * role:monitoring_server
        * recipe:munin_wrapper::server
    * role:monitoring
        * recipe:munin_wrapper::client
 * TODO

* 172.20.10.12 web01 - Web server
 * role:web_server
    * installed on sakura
        * postfix
    * role:base
        * recipe: yum::remi
        * recipe: yum::epel
        * initial_users
            * group : staff
            * user  : devuser
            * /etc/sudoers.d/devuser
            * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
            * ~devuser/backup,shell
        * recipe:openssh
        * recipe:simple_iptables
    * recipe:web_server
        * install packages
            * perl-core
            * nfs-utils
        * hosts
        * iptables for web server in sakura
        * autofs ( /mnt/share )
    * role:web
        * recipe:nginx
        * recipe:mysql::client
        * recipe:php
        * recipe:php::module_mysql
        * recipe:logrotate::nginx
    * role:monitoring
        * recipe:munin_wrapper::client
 * TODO

* 172.20.10.13 db01 - DB server / Storage server
 * role:db_server
    * installed on sakura
        * postfix
    * role:base
        * recipe: yum::remi
        * recipe: yum::epel
        * initial_users
            * group : staff
            * user  : devuser
            * /etc/sudoers.d/devuser
            * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
            * ~devuser/backup,shell
        * recipe:openssh
        * recipe:simple_iptables
    * recipe:nfs::server
    * recipe:db_server
        * install packages
            * perl-core
            * nfs-utils
        * hosts
        * iptables for db server in sakura
        * nfs ( /exports )
        * cron for backup_db
    * role:db
        * recipe:mysql_wrapper::server
    * role:batch
        * recipe:mysql::client
        * recipe:php
        * recipe:php::module_mysql
    * role:monitoring
        * recipe:munin_wrapper::client
 * TODO

## Account

* OS
 * root
 * devuser (root on MySQL (by ~devuser/.my.cnf), admin on gitolite (by gitolite@gitlite-admin:keydir/admin.pub))
 * (vagrant)

* MySQL
 * root
 * repl

* gitolite
 * admin

* munin console
 * munin

## Directory

* Dev
 * /home/devuser/.ssh
 * /home/devuser/backup/dev
 * /home/devuser/backup/db
 * /home/devuser/backup_work
 * /home/devuser/shell
 * /home/gitolite
 * /etc/chef # For encrypted_data_bag_secret.

* Web
 * /home/devuser/.ssh
 * /home/devuser/shell
 * /mnt/share

* DB
 * /home/devuser/.ssh
 * /home/devuser/backup/dev
 * /home/devuser/backup/db
 * /home/devuser/backup_work
 * /home/devuser/shell
 * /exports

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
      <td>Private key for devuser (OS user) and admin (gitolite user)</td>
    </tr>
    <tr>
      <td>id_rsa_devuser.pub</td>
      <td>Public key for devuser (OS user) and admin (gitolite user)</td>
    </tr>
    <tr>
      <td>encrypted_data_bag_secret</td>
      <td>refs. http://docs.opscode.com/essentials_data_bags.html (for password of mysql)</td>
    </tr>
  </tbody>
</table>

### Step

* Startup
 * (Case: vagrant) Execute `vagrant up` in `"initializer"`, and login to dev as root.
 * (Case: not vagrant) Login to dev as root, and execute `initializer/setup.sh`

You can `knife solo cook root@targethost` as root for the first time.
But this cookbooks revoke ssh login from root, you should use `knife solo cook devuser@targethost` as devuser from the second time.
If you use devuser, you must clone this cookbook again, and copy id_rsa_devuser and id_rsa_devuser.pub to devuser work directory.

* As root in Dev (From the second time, root -> devuser)
 * $ `mkdir ~/work`
 * $ `cd ~/work`
 * $ `git clone [app-server-cookbook]` # If you registered certificate to repository, you can use git:. Otherwise, you should use https:. 
 * Upload id_rsa_devuser to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/devuser/id_rsa
 * Upload id_rsa_devuser.pub to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/devuser/id_rsa.pub
 * Upload id_rsa_devuser.pub to ~/work/app-server-cookbook/site-cookbooks/**gitolite**/files/default/gitolite/admin.pub
 * Upload encrypted_data_bag_secret to /etc/chef/encrypted_data_bag_secret
    * Generate by `openssl rand -base64 512 | tr -d '\\r\\n' > /etc/chef/encrypted_data_bag_secret`
 * **Replace `htpasswd` in ~/work/app-server-cookbook/data_bags/users/munin.json**
    * You can generate password by `htpasswd -ns munin` (need apache)
 * Replace IP address (172.20.10.11, 172.20.10.12, 172.20.10.13) and network address (172.20.10.0/24) to your environment. (in roles/ and nodes/)
 * $ `cd ~/work/app-server-cookbook`
 * $ `knife solo data bag edit passwords mysql`
    * Need /etc/chef/encrypted_data_bag_secret
    * If you want show, use `knife solo data bag show passwords mysql`
    * If you want create, use `knife solo data bag create passwords mysql`
    * You should set EDITOR. (e.g. export EDITOR=vi)
 * $ `berks install --path cookbooks`
 * $ `knife solo prepare root@localhost` # From the second time, root -> devuser
 * $ `knife solo cook root@localhost` # From the second time, root -> devuser
    * Enter the root password about 10 times.
    * If you created trusted user (e.g. devuser), you can skip entering password.
    * **WARN: You can no longer ssh login as root. Please use devuser.**
    * **WARN: You should try login as devuser before logout from current root session.**

* As devuser in Dev
 * targethost = web01, db01 (depends on your environment)
    * Start web01 and db01.
    * $ `knife solo prepare root@targethost` # From the second time, root -> devuser
    * $ `knife solo cook root@targethost` # From the second time, root -> devuser
        * Enter the root password about 10 times.
        * If you created trusted user (e.g. devuser), you can skip entering password.

* As devuser in Dev / Web / DB
 * `ssh localhost`, `ssh dev01`, `ssh web01`, `ssh db01` and answer `yes` at each hosts. # For update known_hosts.
    * **WARN: Don't forget own hostname (for self login in backup shell).**

### Checkout configuration repository for gitolite

 * `git clone gitolite@172.20.10.11:gitolite-admin` (depends on your environment)
     * Use id_rsa_devuser.
         * If you use TortoiseGit, you have to convert id_rsa_devuser (OpenSSH format) to id_rsa_devuser.ppk (PuTTY format) by puttygen.

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
 * devuser is too strong.
 * bind-address in /etc/my.cnf is "0.0.0.0" (accept remote access from all interfaces)

* knowledge
 * recipe:mysql_wrapper is not idempotent.
    * If you want to reinstall mysql, preprocess steps are as follows:
        * $ `sudo yum remove -y mysql`
        * $ `sudo rm -rf /var/lib/mysql/;sudo rm /etc/mysql_grants*.sql;sudo rm /etc/my.cnf`

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

