name :dev_server

run_list(
  "role[base]",
  "recipe[dev_server]",
  "role[repository]",
  "role[web]",
  "role[db]",
  "role[monitoring_server]",
  "role[monitoring]"
)

default_attributes(
)

