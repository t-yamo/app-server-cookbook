# Cookbook Name:: sakura
# Recipe:: hosts

## hosts

node["base"]["hosts"].each do |host|
  hostsfile_entry host.ipaddr do
    hostname host.hostname
    unique true
  end
end

