# Cookbook Name:: mysql_wrapper
# Recipe:: server

include_recipe 'mysql::server'

mysql_data = Chef::EncryptedDataBagItem.load("passwords", "mysql")

template '/etc/mysql_grants_wrap.sql' do
  source 'grants.sql.erb'
  owner  'root'
  group  'root'
  mode   '0600'
  action :create
  notifies :run, 'execute[install-grants-wrap]', :immediately
  variables({
    :server_debian_password => mysql_data["server_debian_password"],
    :server_root_password   => mysql_data["server_root_password"],
    :server_repl_password   => mysql_data["server_repl_password"]
  })
end

#cmd = install_grants_cmd
#cmd = "/usr/bin/mysql -u root -p#{mysql_data['server_root_password']} < /etc/mysql_grants_wrap.sql"
cmd = "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < /etc/mysql_grants_wrap.sql"
execute 'install-grants-wrap' do
  command cmd
  action :nothing
  notifies :restart, 'service[mysql]', :immediately
end

template '/home/devuser/.my.cnf' do
  source 'devuser_my.cnf'
  owner  'devuser'
  group  'staff'
  mode   '0600'
  action :create
  variables({
    :server_root_password   => mysql_data["server_root_password"]
  })
end

