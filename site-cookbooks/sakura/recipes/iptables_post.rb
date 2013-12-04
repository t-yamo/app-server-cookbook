# Cookbook Name:: sakura
# Recipe:: iptables_post

## simple_iptables

simple_tables_rule "RH-Firewall-1-INPUT" do
  rule "--reject-with icmp-host-prohibited"
  direction [ "INPUT", "FORWARD" ]
  jump "REJECT"
end

