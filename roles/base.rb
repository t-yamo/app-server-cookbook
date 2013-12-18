name :base

run_list(
  "recipe[yum::remi]",
  "recipe[yum::epel]",
  "recipe[initial_users]",
  "recipe[openssh]",
  "recipe[simple_iptables]"
)

default_attributes(
  :user => {
    :ssh_keygen => "false"
  },
  :openssh => {
    :client => {
      :g_s_s_a_p_i_authentication => "yes",
      :forward_x11_trusted => "yes",
      :send_env => "LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION LC_ALL LANGUAGE XMODIFIERS"
    },
    :server => {
      :protocol => 2,
      :syslog_facility => "AUTHPRIV",
      :permit_root_login => "no",
      :r_s_a_authentication => "yes",
      :pubkey_authentication => "yes",
      :authorized_keys_file => ".ssh/authorized_keys",
      :password_authentication => "yes",
      :challenge_response_authentication => "no",
      :g_s_s_a_p_i_authentication => "yes",
      :g_s_s_a_p_i_cleanup_credentials => "yes",
      :use_p_a_m => "yes",
      :accept_env => "LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION LC_ALL LANGUAGE XMODIFIERS",
      :x11_forwarding => "yes",
      :subsystem => "sftp    /usr/libexec/openssh/sftp-server"
    }
  }
)

