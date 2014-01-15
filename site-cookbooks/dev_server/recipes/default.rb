# Cookbook Name:: dev_server
# Recipe:: default

## packages

include_recipe "sakura::packages"

## hosts

include_recipe "sakura::hosts"

## simple_iptables

include_recipe "sakura::iptables_pre"

# workaround: simple_iptables don't support multiple direction
iptables_web_server_arr = [
  # for web server
  "-m state --state NEW -m tcp -p tcp --dport 80",
  "-m state --state NEW -m tcp -p tcp --dport 443",
  # for db server
  # MySQL
  "-m state --state NEW -m tcp -p tcp --dport 3306",
  # munin server
  "-m state --state NEW -m tcp -p tcp --dport 8080",
  # munin-node
  "-m state --state NEW -m tcp -p tcp --dport 4949"
]

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule iptables_web_server_arr
  direction "INPUT"
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

