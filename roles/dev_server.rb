name :dev_server

run_list(
  "role[base]",
  "recipe[dev_server]",
  "recipe[gitolite]",
  "role[partial_web]"
)

