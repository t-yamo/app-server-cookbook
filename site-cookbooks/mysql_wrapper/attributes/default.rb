# Cookbook Name:: mysql_wrapper
# Attributes:: default

# dummy data for cookbook mysql.
# mysql_wrapper will overwrite them by another recipe.
default["mysql"]["server_debian_password"] = "password"
default["mysql"]["server_root_password"]   = "password"
default["mysql"]["server_repl_password"]   = "password"

