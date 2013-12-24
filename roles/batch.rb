name :batch

run_list(
  "recipe[mysql::client]",
  "recipe[php]",
  "recipe[php::module_mysql]",
  "recipe[php::module_fpdf]"
)

default_attributes(
)

