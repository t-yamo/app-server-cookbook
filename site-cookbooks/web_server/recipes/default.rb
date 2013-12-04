# Cookbook Name:: web_server
# Recipe:: default

## simple_iptables

include_recipe "sakura::iptables_pre"

# workaround: simple_iptables don't support multiple direction
iptables_web_server_arr = [
  "-m state --state NEW -m tcp -p tcp --dport 80",
  "-m state --state NEW -m tcp -p tcp --dport 443"
]

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule iptables_web_server_arr
  direction "INPUT"
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

