class puppet_server::data {
  ## Managed data file
  if $puppet_server::datadir {
    create_resources(puppet_server::datadir,$puppet_server::datadir)
  }
}
