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
 * roles:base
    * initial_user
        * group : staff
        * user  : devuser
        * /etc/sudoers.d/devuser
        * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
    * openssh
    * simple_iptables
 * roles:dev_server
    * dev_server
        * iptables for dev server in sakura
    * gitolite
 * installed on sakura
    * postfix
 * TODO
    * gitolite
    * nginx (for development, sorry page, munin console)
    * php (for development)
    * mysql (for development)
    * munin
    * munin-node

* 172.20.10.12 Web server
 * roles:base
    * initial_user
        * group : staff
        * user  : devuser
        * /etc/sudoers.d/devuser
        * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
    * openssh
 * roles:web_server
    * web_server
        * iptables for web server in sakura
        * autofs ( /mnt/share )
 * installed on sakura
    * postfix
 * TODO
    * nginx
    * php
    * munin-node

* 172.20.10.13 DB server / Storage server
 * roles:base
    * initial_user
        * group : staff
        * user  : devuser
        * /etc/sudoers.d/devuser
        * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
    * openssh
 * roles:db_server
    * nfs::server
    * db_server
        * iptables for db server in sakura
        * nfs ( /exports )
 * TODO
    * mysql
    * munin-node

## Setup

* Startup
 * (Case: vagrant) execute "vagrant up" in "initializer", and login to dev as root.
 * (Case: not vagrant) login to dev as root, and execute "initializer/setup.sh"

You can "knife solo cook root@targethost" as root for the first time.
But this cookbooks revoke ssh login from root, you should use "knife solo cook devuser@targethost" as devuser from the second time.

* As root in Dev (From the second time, root -> devuser)
 * $ mkdir ~/work
 * $ cd ~/work
 * $ git clone [app-server-cookbook]
 * upload id_rsa_devuser to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/devuser/id_rsa
 * upload id_rsa_devuser.pub to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/devuser/id_rsa.pub
 * upload id_rsa_gitolite_admin.pub to ~/work/app-server-cookbook/site-cookbooks/initial_users/files/default/gitolite/admin.pub
 * $ cd ~/work/app-server-cookbook
 * $ berks install --path cookbooks
 * $ knife solo cook root@localhost # From the second time, root -> devuser
    * **WARN: You can no longer ssh login as root. Please use devuser.**
    * **WARN: You should try login as devuser before logout from current root session.**

* As devuser in Dev
 * targethost = 172.20.10.12, 172.20.10.13
    * $ knife solo prepare root@targethost # From the second time, root -> devuser
    * $ knife solo cook root@targethost # From the second time, root -> devuser
        * Enter the root password about 10 times.
        * If you created trusted user (e.g. devuser), you can skip entering password.

### Windows (untested)

* Virtual Box
 * https://www.virtualbox.org/wiki/Downloads
* Vagrant
 * http://www.vagrantup.com/downloads.html
* Chef
 * http://www.getchef.com/chef/install/
* Ruby DevKit
 * http://rubyinstaller.org/downloads
    * ruby dk.rb init
    * ruby dk.rb install
* knife-solo
 * gem install knife-solo --no-rdoc --no-ri

## Note

* Security Issues
 * Enabled PasswordAuthentication, RSAAuthentication and PubkeyAuthentication. 
 * devuser can sudo without password (with NOPASSWD option).

## Refs.

* http://www.slideshare.net/JulianDunn/beginner-chef-antipatterns
* http://www.creationline.com/lab/3080
* http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns/
* http://qiita.com/mokemokechicken/items/8369ff19453f73913f1e

