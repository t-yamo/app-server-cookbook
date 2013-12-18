#!/bin/sh

# install git
yum install -y git

# add group staff
groupadd -g 601 staff

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
gem install chef knife-solo berkshelf knife-solo_data_bag --no-ri --no-rdoc
rbenv rehash

