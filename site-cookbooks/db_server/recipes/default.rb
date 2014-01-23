# Cookbook Name:: db_server
# Recipe:: default

## packages

include_recipe "sakura::packages"

## hosts

include_recipe "sakura::hosts"

## simple_iptables

include_recipe "sakura::iptables_pre"

# workaround: simple_iptables don't support multiple direction
iptables_db_server_arr = [
  # NFSv4
  "-m state --state NEW -m tcp -p tcp --dport 2049",
  # MySQL
  "-m state --state NEW -m tcp -p tcp --dport 3306",
  # munin-node
  "-m state --state NEW -m tcp -p tcp --dport 4949"
]

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule iptables_db_server_arr
  direction "INPUT"
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

## nfs

directory node["db_server"]["shared_dir_server"] do
  owner "root"
  group "staff"
  mode  "2775"
end

nfs_export node["db_server"]["shared_dir_server"] do
  network node["db_server"]["network"]
  writeable true
  sync true
  options [ "root_squash" ]
end

## backup

cron "backup_db" do
  minute   "40"
  hour     "2"
  user     node["initial_users"]["dev_user"]
  mailto   node["initial_users"]["dev_user"]
  command  "/home/" + node["initial_users"]["dev_user"] + "/shell/backup_db.sh"
  only_if do File.exists?("/home/" + node["initial_users"]["dev_user"] + "/shell/backup_db.sh") end
end

