name "base"

runlist
  "recipe[user]",
  "recipe[sudo]",
  "recipe[openssh]"

default_attributes(
  "openssh" : {
    "server" : {
      "permit_root_login" : "no"
      "password_authentication" : "no"
    }
  }
)

