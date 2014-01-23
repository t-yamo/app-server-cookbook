# Cookbook Name:: web_server
# Recipe:: default

## packages

include_recipe "sakura::packages"

## hosts 

include_recipe "sakura::hosts"

## simple_iptables

include_recipe "sakura::iptables_pre"

# workaround: simple_iptables don't support multiple direction
iptables_web_server_arr = [
  "-m state --state NEW -m tcp -p tcp --dport 80",
  "-m state --state NEW -m tcp -p tcp --dport 443",
  # munin-node
  "-m state --state NEW -m tcp -p tcp --dport 4949"
]

simple_iptables_rule "RH-Firewall-1-INPUT" do
  rule iptables_web_server_arr
  direction "INPUT"
  jump "ACCEPT"
end

include_recipe "sakura::iptables_post"

## autofs

directory "/mnt/#{node["web_server"]["shared_dir_client"]}" do
  owner "root"
  group "staff"
  mode  "2775"
end

package "autofs" do
  action [ :install, :upgrade ]
end

execute "auto.master" do
  command <<-EOT
    echo '/misc   /etc/auto.misc'               > /etc/auto.master
    echo '/mnt    /etc/auto.mnt --timeout=300' >> /etc/auto.master
    echo '/net    -hosts'                      >> /etc/auto.master
    echo '+auto.master'                        >> /etc/auto.master
  EOT
end

execute "auto.mnt" do
  command "echo '#{node["web_server"]["shared_dir_client"]} -fstype=nfs,rw #{node["web_server"]["shared_server"]}:#{node["web_server"]["shared_dir_server"]}' > /etc/auto.mnt"
end

service "autofs" do
  action :restart
end

