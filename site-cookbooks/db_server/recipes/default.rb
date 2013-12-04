# Cookbook Name:: db_server
# Recipe:: default

## simple_iptables

include_recipe "sakura::iptables_pre"

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule [
    "-m state --state NEW -m tcp -p tcp --dport 2049",
    "-m state --state NEW -m tcp -p tcp --dport 3306"
  ]
  direction "INPUT"
  jump "ACCEPT"
end

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule [
    "-m state --state NEW -m tcp -p tcp --dport 2049",
    "-m state --state NEW -m tcp -p tcp --dport 3306"
  ]
  direction "FORWARD"
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

