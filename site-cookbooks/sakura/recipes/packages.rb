# Cookbook Name:: sakura
# Recipe:: packages

# install packages for nginx and gitolite

%w{ perl-core }.each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

