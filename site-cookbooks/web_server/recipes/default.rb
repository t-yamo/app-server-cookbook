# Cookbook Name:: web_server
# Recipe:: default

## simple_iptables

include_recipe "sakura::iptables_pre"

simple_tables_rule "RH-Firewall-1-INPUT" do
  rule [
    "-m state --state NEW -m tcp -p tcp --dport 80",
    "-m state --state NEW -m tcp -p tcp --dport 443",
  ]
  direction [ "INPUT", "FORWARD" ]
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

