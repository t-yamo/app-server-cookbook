# Cookbook Name:: sakura
# Recipe:: iptables_post

## simple_iptables

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule "--reject-with icmp-host-prohibited"
  direction "INPUT"
  jump "REJECT"
end

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule "--reject-with icmp-host-prohibited"
  direction "FORWARD"
  jump "REJECT"
end

