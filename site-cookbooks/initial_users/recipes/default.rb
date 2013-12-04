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
  action  :modify
  append  true
  members [ "devuser" ]
end

file "/etc/sudoers.d/devuser" do
  owner    "root"
  group    "root"
  mode     0400
  content  "devuser ALL=(ALL) ALL"
end

