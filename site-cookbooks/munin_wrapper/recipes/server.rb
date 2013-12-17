# Cookbook Name:: munin_wrapper
# Recipe:: server

include_recipe "munin::server_nginx"

%w(default 000-default).each do |enable_site|
  nginx_site enable_site
end

munin_conf = File.join(node['nginx']['dir'], 'sites-available', 'munin.conf')

template munin_conf do
  source   'nginx.conf.erb'
  mode     '0644'
  notifies :reload, 'service[nginx]' if ::File.symlink?(munin_conf)
end

