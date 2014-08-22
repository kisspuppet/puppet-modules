class normal::data {
  ## Managed data file
  if $normal::datadir {
    create_resources(normal::datadir,$normal::datadir)
  }
}
