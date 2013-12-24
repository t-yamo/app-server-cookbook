name :db

run_list(
  "recipe[mysql_wrapper::server]"
)

default_attributes(
  :mysql => {
    :bind_address => "0.0.0.0",
    :allow_remote_root => false,
    :remove_anonymous_users => true,
    :remove_test_database => true,
    :root_network_acl => "172.20.10.0/255.255.255.0"
  },
  :mysql_wrapper => {
    :repl_network_acl => "172.20.10.0/255.255.255.0"
  }
)

