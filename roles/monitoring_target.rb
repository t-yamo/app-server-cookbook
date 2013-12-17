name :monitoring_target

run_list(
  "recipe[munin::client]"
)

