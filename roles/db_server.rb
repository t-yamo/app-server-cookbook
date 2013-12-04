name :db_server

run_list(
  "role[base]",
  "recipe[db_server]"
)

