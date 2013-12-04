# Cookbook Name:: sakura
# Recipe:: iptables_pre

## simple_iptables

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule [
    "-i lo",
    "-p icmp --icmp-type any",
    "-p 50",
    "-p 51",
    "-p udp -m udp --dport 5353 -d 224.0.0.251",
    "-p udp -m udp --dport 631",
    "-p udp -m udp --dport 631",
    "-m state --state ESTABLISHED,RELATED",
    "-m state --state NEW -m tcp -p tcp --dport 22"
  ]
  direction "INPUT"
  jump "ACCEPT"
end

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule [
    "-i lo",
    "-p icmp --icmp-type any",
    "-p 50",
    "-p 51",
    "-p udp -m udp --dport 5353 -d 224.0.0.251",
    "-p udp -m udp --dport 631",
    "-p udp -m udp --dport 631",
    "-m state --state ESTABLISHED,RELATED",
    "-m state --state NEW -m tcp -p tcp --dport 22"
  ]
  direction "FORWARD"
  jump "ACCEPT"
end

