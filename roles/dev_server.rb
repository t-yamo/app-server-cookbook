name :dev_server

run_list(
  "role[base]",
  "recipe[dev_server]",
  "role[repository]",
  "role[web]"
)

