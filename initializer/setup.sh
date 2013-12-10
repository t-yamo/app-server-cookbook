#!/bin/sh

DEV_USER=devuser

KEYPAIR_DIR=$1
INITIAL_USER=$2

if [ -n "${KEYPAIR_DIR}" ]; then
  echo "usage: setup.sh <KEYPAIR_DIR> <INITIAL_USER>"
  exit 1
fi

if [ -n "${INITIAL_USER}" ]; then
  echo "usage: setup.sh <KEYPAIR_DIR> <INITIAL_USER>"
  exit 1
fi

# install git
yum install -y git

# add group staff
groupadd -g 601 staff
usermod -a -G staff ${INITIAL_USER}

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
#mkdir -p ~${INITIAL_USER}/.ssh
#chown ${INITIAL_USER}:${INITIAL_USER} ~${INITIAL_USER}/.ssh
#chmod 700 ~${INITIAL_USER}/.ssh
#install -o ${INITIAL_USER} -g ${INITIAL_USER} -m 600 ${KEYPAIR_DIR}/id_rsa_git ~${INITIAL_USER}/.ssh/id_rsa
#install -o ${INITIAL_USER} -g ${INITIAL_USER} -m 644 ${KEYPAIR_DIR}/id_rsa.pub_git ~${INITIAL_USER}/.ssh/id_rsa.pub

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
echo "00. login devuser to dev"
echo "(01. # knife configure)"
echo "02. clone cookbooks from git."
echo "03. cd git project (cloned cookbooks)."
echo "04. # berks install --path cookbooks"
echo "05. # knife solo prepare user@targethost"
echo "06. # knife solo cook root@targethost"
echo "      Enter the root password about 10 times."
echo "      If you created trusted user, you can skip entering password."

