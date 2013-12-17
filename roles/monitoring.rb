name :monitoring_target

run_list(
  "recipe[munin_wrapper::client]"
)

default_attributes(
  :munin_wrapper => {
    :munin_servers => [
      { :fqdn => "dev", :ipaddress => "172.20.10.11" }
    ]
  }
)

