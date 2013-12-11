#!/bin/sh

DEV_USER=devuser
ROOT_HOME=/root

KEYPAIR_DIR=${1?"usage: setup.sh <KEYPAIR_DIR>"}

# install git
yum install -y git

# add group staff
groupadd -g 601 staff
usermod -a -G staff root

# create devuser
useradd -u 601 -g staff -G wheel ${DEV_USER}

# install rbenv for global env
# refs. http://qiita.com/semind/items/8e973a544b592376a07e
# g+rwxXs -> g+rwXs ?
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
chgrp -R staff rbenv
chmod -R g+rwXs rbenv

# install ruby-build for global env
# refs. http://qiita.com/semind/items/8e973a544b592376a07e
# g+rwxs -> g+rwXs ?
mkdir /usr/local/rbenv/plugins
cd /usr/local/rbenv/plugins
git clone git://github.com/sstephenson/ruby-build.git
chgrp -R staff ruby-build
chmod -R g+rwXs ruby-build

# add path
echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile
echo 'eval "$(rbenv init -)"' >> /etc/profile

# source global profile
. /etc/profile

# install ruby by rbenv
rbenv install 2.0.0-p353
rbenv rehash
rbenv global 2.0.0-p353

# for CentOS6
# refs. http://www.ideaxidea.com/archives/2013/08/resolv.html
echo 'options single-request-reopen' >> /etc/resolv.conf

# install chef, knife-solo, berkshelf and bundler by rbenv
gem install bundler --no-ri --no-rdoc
rbenv rehash
gem install chef knife-solo berkshelf --no-ri --no-rdoc
rbenv rehash

# copy key pair for git
mkdir -p ${ROOT_HOME}/.ssh
chmod 700 ${ROOT_HOME}/.ssh
install -o root -g root -m 600 ${KEYPAIR_DIR}/id_rsa_gituser ${ROOT_HOME}/.ssh/id_rsa_gituser
install -o root -g root -m 644 ${KEYPAIR_DIR}/id_rsa_gituser.pub ${ROOT_HOME}/.ssh/id_rsa_gituser.pub

# copy key pair for devuser
mkdir -p /home/${DEV_USER}/.ssh
chown ${DEV_USER}:staff /home/${DEV_USER}/.ssh
chmod 700 /home/${DEV_USER}/.ssh
install -o ${DEV_USER} -g staff -m 600 ${KEYPAIR_DIR}/id_rsa_devuser /home/${DEV_USER}/.ssh/id_rsa
install -o ${DEV_USER} -g staff -m 644 ${KEYPAIR_DIR}/id_rsa_devuser.pub /home/${DEV_USER}/.ssh/id_rsa.pub
cat /home/${DEV_USER}/.ssh/id_rsa.pub >> /home/${DEV_USER}/.ssh/authorized_keys
chown ${DEV_USER}:staff /home/${DEV_USER}/.ssh/authorized_keys
chmod 600 /home/${DEV_USER}/.ssh/authorized_keys

# activate RSA Authentication
sed -i -e "s/^#RSAAuthentication/RSAAuthentication/g" /etc/ssh/sshd_config
sed -i -e "s/^#PubkeyAuthentication/PubkeyAuthentication/g" /etc/ssh/sshd_config
sed -i -e "s/^#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config
service sshd restart

# message
echo "Next Step..."
echo "01. login ${DEV_USER} to dev"
echo "02. remove ${KEYPAIR_DIR}."
echo "03. clone cookbooks from git. (modify ~root/.ssh/config for ~root/.ssh/id_rsa_git)"
echo "04. (app-server-cookbook) copy /home/${DEV_USER}/.ssh/id_rsa to <chef>/site-cookbooks/initial_users/files/default/${DEV_USER}/id_rsa"
echo "05. (app-server-cookbook) copy /home/${DEV_USER}/.ssh/id_rsa.pub to <chef>/site-cookbooks/initial_users/files/default/${DEV_USER}/id_rsa.pub"
echo "06. cd git project (cloned cookbooks)."
echo "07. \$ knife configure"
echo "08. \$ berks install --path cookbooks"
echo "09. \$ knife solo prepare user@targethost"
echo "10. \$ knife solo cook root@targethost"
echo "      Enter the root password about 10 times."
echo "      If you created trusted user, you can skip entering password."

