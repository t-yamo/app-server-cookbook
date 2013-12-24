# Cookbook Name:: logrotate
# Recipe:: nginx

template "/etc/logrotate.d/nginx" do
  source "nginx.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  action :create
end

