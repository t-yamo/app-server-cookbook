name :db

run_list(
  "recipe[mysql_wrapper::server]"
)

default_attributes(
)

