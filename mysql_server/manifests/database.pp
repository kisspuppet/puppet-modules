class mysql_server::database {
  if $mysql_server::grant and !$mysql_server::absent {
    create_resources(mysql_server::grant,$mysql_server::grant)
  }
}
