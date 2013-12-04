# Cookbook Name:: db_server
# Recipe:: default

## simple_iptables

include_recipe "sakura::iptables_pre"

# workaround: simple_iptables don't support multiple direction
iptables_db_server_arr = [
  "-m state --state NEW -m tcp -p tcp --dport 2049",
  "-m state --state NEW -m tcp -p tcp --dport 3306"
]

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule iptables_db_server_arr
  direction "INPUT"
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

