name :base

runlist
  "recipe[user]",
  "recipe[sudo]",
  "recipe[openssh]",
  "recipe[simple_iptables]"

default_attributes(
  ## user
  # to data_bags/users
  ## sudo
  :authorization : {
    :sudo : {
      :users : [ "devuser" ],
      :passwordless : "true"
    }
  },
  ## openssh
  :openssh : {
    :server : {
      :permit_root_login : "no",
      :password_authentication : "no"
    }
  }
)

