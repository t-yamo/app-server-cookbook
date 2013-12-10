# Cookbook Name:: initial_users
# Recipe:: default

group "staff" do
  gid      601
end

user_account "devuser" do
  uid      601
  gid      "staff"
end

group "wheel" do
  action   :modify
  append   true
  members  [ "devuser" ]
end

file "/etc/sudoers.d/devuser" do
  owner    "root"
  group    "root"
  mode     0400
  content  "devuser ALL=(ALL) ALL"
end

directory "/home/devuser/.ssh" do
  owner    "devuser"
  group    "staff"
  mode     0700
end

cookbook_file "/home/devuser/.ssh/id_rsa" do
  source   "devuser/id_rsa"
  owner    "devuser"
  group    "staff"
  mode     0600
end

cookbook_file "/home/devuser/.ssh/id_rsa.pub" do
  source   "devuser/id_rsa.pub"
  owner    "devuser"
  group    "staff"
  mode     0644
end

cookbook_file "/home/devuser/.ssh/authorized_keys" do
  source   "devuser/id_rsa.pub"
  owner    "devuser"
  group    "staff"
  mode     0600
end

