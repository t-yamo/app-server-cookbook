# Cookbook Name:: sakura
# Recipe:: iptables_post

## simple_iptables

# We use DROP instead of REJECT
# simple_iptables_rule "RH-Firewall-1-INPUT" do
#   rule ""
#   direction "INPUT"
#   # workaround: iptables v1.4.7: unknown option `--reject-with'
#   jump "REJECT --reject-with icmp-host-prohibited"
# end

