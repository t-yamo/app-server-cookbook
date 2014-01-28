name :batch

run_list(
  "recipe[mysql::client]",
  "recipe[php]",
  "recipe[php::module_mysql]"
)

default_attributes(
)

