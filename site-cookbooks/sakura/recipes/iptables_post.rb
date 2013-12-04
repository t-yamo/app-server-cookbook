# Cookbook Name:: sakura
# Recipe:: iptables_post

## simple_iptables

# workaround: simple_iptables don't support multiple direction

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule ""
  direction "INPUT"
  # workaround: iptables v1.4.7: unknown option `--reject-with'
  jump "REJECT --reject-with icmp-host-prohibited"
end

simple_iptables_rule "RH-Firewall-1-FORWARD" do
  rule ""
  direction "FORWARD"
  # workaround: iptables v1.4.7: unknown option `--reject-with'
  jump "REJECT --reject-with icmp-host-prohibited"
end

