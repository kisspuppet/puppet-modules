class standard::data {
  ## Managed data file
  if $standard::datadir {
    create_resources(standard::datadir,$standard::datadir)
  }
}
