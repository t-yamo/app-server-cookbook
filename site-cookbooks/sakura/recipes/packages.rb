# Cookbook Name:: sakura
# Recipe:: packages

## install packages for nginx and gitolite and NFS client

%w{ perl-core nfs-utils }.each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

