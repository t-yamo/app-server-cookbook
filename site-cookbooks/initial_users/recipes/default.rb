# Cookbook Name:: initial_users
# Recipe:: default

group "staff" do
  gid      601
end

user_account node["initial_users"]["dev_user"] do
  uid      601
  gid      "staff"
end

group "wheel" do
  action   :modify
  append   true
  members  [ node["initial_users"]["dev_user"] ]
end

file "/etc/sudoers.d/" + node["initial_users"]["dev_user"] do
  owner    "root"
  group    "root"
  mode     "0400"
  content  node["initial_users"]["dev_user"] + " ALL=(ALL) NOPASSWD:ALL"
end

directory "/home/" + node["initial_users"]["dev_user"] + "/.ssh" do
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0700"
end

cookbook_file "/home/" + node["initial_users"]["dev_user"] + "/.ssh/id_rsa" do
  source   node["initial_users"]["dev_user"] + "/id_rsa"
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0600"
end

cookbook_file "/home/" + node["initial_users"]["dev_user"] + "/.ssh/id_rsa.pub" do
  source   node["initial_users"]["dev_user"] + "/id_rsa.pub"
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0644"
end

cookbook_file "/home/" + node["initial_users"]["dev_user"] + "/.ssh/authorized_keys" do
  source   node["initial_users"]["dev_user"] + "/id_rsa.pub"
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0600"
end

# for backup

directory "/home/" + node["initial_users"]["dev_user"] + "/backup/dev" do
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0755"
  recursive true
end

directory "/home/" + node["initial_users"]["dev_user"] + "/backup/db" do
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0755"
  recursive true
end

directory "/home/" + node["initial_users"]["dev_user"] + "/shell" do
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0755"
end

template "/home/" + node["initial_users"]["dev_user"] + "/shell/backup_function.sh" do
  source   "backup_function.sh.erb"
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0755"
end

template "/home/" + node["initial_users"]["dev_user"] + "/shell/backup_dev.sh" do
  source   "backup_dev.sh.erb"
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0755"
end

template "/home/" + node["initial_users"]["dev_user"] + "/shell/backup_db.sh" do
  source   "backup_db.sh.erb"
  owner    node["initial_users"]["dev_user"]
  group    "staff"
  mode     "0755"
end

