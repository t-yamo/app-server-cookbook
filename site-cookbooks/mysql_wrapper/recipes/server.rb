# Cookbook Name:: mysql_wrapper
# Recipe:: server

include_recipe 'mysql::server'

mysql_data = Chef::EncryptedDataBagItem.load("passwords", "mysql")

template '/etc/mysql_grants.sql' do
  source 'grants.sql.erb'
  owner  'root'
  group  'root'
  mode   '0600'
  action :create
  notifies :run, 'execute[install-grants]', :immediately
  variables({
    :server_debian_password => mysql_data["server_debian_password"],
    :server_root_password   => mysql_data["server_root_password"],
    :server_repl_password   => mysql_data["server_repl_password"]
  })
end

cmd = install_grants_cmd
#cmd = "/usr/bin/mysql -u root -p#{mysql_data['server_root_password']} < /etc/mysql_grants.sql"
execute 'install-grants' do
  command cmd
  action :nothing
  notifies :restart, 'service[mysql]', :immediately
end

