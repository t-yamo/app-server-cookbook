name :monitoring

run_list(
  "recipe[munin_wrapper::server]"
)

default_attributes(
  :munin => {
    :web_server_port => 8080,
    :web_server => "nginx",
    :server_auth_method => "htauth"
  },
  :munin_wrapper => {
    :munin_clients => [
      { :fqdn => "dev01", :ipaddress => "172.20.10.11" },
      { :fqdn => "web01", :ipaddress => "172.20.10.12" },
      { :fqdn => "db01",  :ipaddress => "172.20.10.13" }
    ]
  }
)

