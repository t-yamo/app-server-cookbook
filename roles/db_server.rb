name :db_server

run_list(
  "role[base]",
  "recipe[nfs]",
  "recipe[db_server]"
)

default_attributes(
  :nfs => {
    :v2 => "no",
    :v3 => "no"
  }
)

