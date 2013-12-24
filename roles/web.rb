name :web

run_list(
  "recipe[nginx]",
  "recipe[mysql::client]",
  "recipe[php]",
  "recipe[php::module_mysql]",
  "recipe[php::module_fpdf]"
)

default_attributes(
  :nginx => {
    :version => "1.4.4",
    :install_method => "source",
    :source => {
      :version => "1.4.4",
    },
    :worker_processes => 2,
    :configure_flags => %w[
      --with-http_ssl_module
      --with-http_gzip_static_module
      --with-http_stub_status_module
      --with-http_perl_module
    ]
  }
)

