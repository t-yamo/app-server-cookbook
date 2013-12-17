# Cookbook Name:: db_server
# Recipe:: default

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
  mode 02775
end

nfs_export node["db_server"]["shared_dir_server"] do
  network node["db_server"]["network"]
  writeable true
  sync true
  options [ "root_squash" ]
end

