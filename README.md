# Cookbooks for App Server

## Description

* 172.20.10.11 Dev Server (Chef)
* 172.20.10.12 Web Server
* 172.20.10.13 DB Server / Storage Server

You can "knife solo cook root@targethost" for the first time.
But this cookbooks revoke ssh login from root, you should use "knife solo cook devuser@targethost" from the second time.

## Setup

* put id_rsa_gituser, id_rsa_gituser.pub, id_rsa_devuser, id_rsa_devuser.pub to keypaier_dir.
* (Case: vagrant) execute "vagrant up" in "initializer".
* (Case: not vagrant) root login to dev, and execute "initializer/setup.sh root /tmp/devuser"
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


## Refs.

* http://www.slideshare.net/JulianDunn/beginner-chef-antipatterns
* http://www.creationline.com/lab/3080
* http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns/
* Chef-Soloの構成についての考察
 * http://qiita.com/mokemokechicken/items/8369ff19453f73913f1e

