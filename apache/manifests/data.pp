class apache::data {
  ## Managed data file
  if $apache::datadir {
    create_resources(apache::datadir,$apache::datadir)
  }
}
