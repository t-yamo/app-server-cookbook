# Cookbook Name:: gitolite
# Recipe:: default

HOME="/home/gitolite"
GITOLITE="gitolite"
ADMIN="admin"

# for gitolite (OS user)
# OS user "gitolite" can use shell ONLY by "su - git"
# from some other userid on the same server.

user_account GITOLITE do
  system_user true
  ssh_keygen  false
end

# for admin (gitolite user)

cookbook_file HOME + "/" + ADMIN + ".pub" do
  source   GITOLITE + "/" + ADMIN + ".pub"
  owner    GITOLITE
  group    GITOLITE
  mode     0644
end

# install

git HOME + "/gitolite" do
  repository "git://github.com/sitaramc/gitolite"
  reference  "master"
  action     :sync
  user       GITOLITE
  group      GITOLITE
end

directory HOME + "/bin" do
  owner GITOLITE
  group GITOLITE
end

execute "gitolite/install -to " + HOME + "/bin" do
  user  GITOLITE
  group GITOLITE
  cwd   HOME
  environment "HOME" => HOME
  creates HOME + "/.gitolite"
end

execute HOME + "/bin/gitolite setup -pk " + ADMIN + ".pub" do
  user  GITOLITE
  group GITOLITE
  cwd   HOME
  environment "HOME" => HOME
  creates HOME + "/.gitolite"
end

