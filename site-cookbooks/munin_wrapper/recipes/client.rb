# Cookbook Name:: munin_wrapper
# Recipe:: client

include_recipe 'munin::client'

service_name = node['munin']['service_name']

munin_servers = node['munin_wrapper']['munin_servers']

template "#{node['munin']['basedir']}/munin-node.conf" do
  source 'munin-node.conf.erb'
  mode   '0644'
  variables :munin_servers => munin_servers
  notifies :restart, "service[#{service_name}]"
end

