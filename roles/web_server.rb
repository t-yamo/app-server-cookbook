name :web_server

run_list(
  "role[base]",
  "recipe[web_server]",
  "role[partial_web]"
)

default_attributes(
  :web_server => {
    :shared_server => "172.20.10.13"
  }
)

