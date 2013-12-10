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

## autofs

directory "/mnt/#{node["app_server"]["shared_dir_client"]}" do
end

package "autofs" do
  action [ :install, :upgrade ]
end

execute "auto.master" do
  command "echo '/mnt /etc/auto.mnt --timeout=300' >> /etc/auto.master"
end

execute "auto.mnt" do
  command "echo '#{node["app_server"]["shared_dir_client"]} -fstype=nfs,rw #{node["app_server"]["shared_server"]}:#{node["app_server"]["shared_dir_server"]}' >> /etc/auto.mnt"
end

