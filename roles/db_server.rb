name :db_server

run_list(
  "role[base]",
  "recipe[nfs::server]",
  "recipe[db_server]",
  "role[db]",
  "role[monitoring]"
)

default_attributes(
  :db_server => {
    :network => "172.20.10.0/24"
  },
  :nfs => {
    :v2 => "no",
    :v3 => "no"
  }
)

