name :dev_server

run_list(
  "role[base]",
  "recipe[dev_server]",
  "recipe[gitolite]",
  "recipe[nginx]"
)

default_attributes(
  :nginx => {
    :version => "1.4.4",
    :install_method => "source",
    :source => {
      :version => "1.4.4",
      :modules => %w[
        nginx::http_ssl_module
        nginx::http_gzip_static_module
        nginx::http_stub_status_module
        nginx::http_perl_module
#        nginx::http_realip_module
#        nginx::passenger
      ]
    }
  }
)

