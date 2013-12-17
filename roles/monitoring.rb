name :monitoring

run_list(
  "recipe[munin::server]"
)

default_attributes(
  :munin => {
    :web_server_port => 8080,
    :web_server => "nginx",
    :server_auth_method => "htauth"
  }
)

