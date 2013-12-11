# Cookbooks for App Server

## Description

* 172.20.10.11 Dev Server ( Chef )
 * script
    * group : staff
    * user  : devuser
    * rbenv
    * ruby-buid
    * ruby 2.x
    * echo 'options single-request-reopen' >> /etc/resolv.conf
    * bundler
    * chef
    * ~root/.ssh/id_rsa_gituser,id_rsa_gituser.pub
    * ~devuser/.ssh/id_rsa,id_rsa.pub,authorized_keys
    * /etc/ssh/sshd_config
        * RSAAuthentication
        * PubkeyAuthentication
        * AuthorizedKeysFile
 * TODO
    * git
    * gitolite
    * nginx (sorry page, munin console)
    * php
    * postfix
    * mysql
    * munin
    * munin-node
* 172.20.10.12 Web Server
 * base
    * initial_user
        * group : staff
        * user  : devuser
        * /etc/sudoers.d/devuser
        * ~/.ssh/id_rsa,id_rsa.pub,authorized_keys
    * openssh
 * web_server
    * iptables for web server in sakura
    * autofs ( /mnt/share )
 * TODO
    * nginx
    * php
    * postfix
    * munin-node
* 172.20.10.13 DB Server / Storage Server
 * base
    * initial_user
        * group : staff
        * user  : devuser
        * /etc/sudoers.d/devuser
        * ~/.ssh/id_rsa,id_rsa.pub,authorized_keys
    * openssh
 * web_server
    * iptables for db server in sakura
    * nfs ( /exports )
 * TODO
    * mysql
    * munin-node

You can "knife solo cook root@targethost" for the first time.
But this cookbooks revoke ssh login from root, you should use "knife solo cook devuser@targethost" from the second time.

## Setup

* put id_rsa_gituser, id_rsa_gituser.pub, id_rsa_devuser, id_rsa_devuser.pub to keypaier_dir(e.g. /vagrant).
* (Case: vagrant) execute "vagrant up" in "initializer".
* (Case: not vagrant) root login to dev, and execute "initializer/setup.sh /vagrant"
* devuser login to dev.
* remove keypair_dir.
* clone app-server-cookbooks from git.
* copy /home/devuser/.ssh/id_rsa to <chef>/site-cookbooks/initial_users/files/default/devuser/id_rsa"
* copy /home/devuser/.ssh/id_rsa.pub to <chef>/site-cookbooks/initial_users/files/default/devuser/id_rsa.pub"
* cd app-server-cookbooks.
* "knife configure"
* "berks install --path cookbooks"
* "knife solo prepare user@targethost"
* "knife solo cook root@targethost"
 * Enter the root password about 10 times.
 * If you created trusted user, you can skip entering password.

### Windows

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

* TODO: avoid passwordless sudo.

## Refs.

* http://www.slideshare.net/JulianDunn/beginner-chef-antipatterns
* http://www.creationline.com/lab/3080
* http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns/
* Chef-Soloの構成についての考察
 * http://qiita.com/mokemokechicken/items/8369ff19453f73913f1e

