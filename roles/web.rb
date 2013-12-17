name :web

run_list(
  "recipe[nginx]"
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

