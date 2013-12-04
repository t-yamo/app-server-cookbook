name :web_server

run_list(
  "role[base]",
  "recipe[web_server]"
)

