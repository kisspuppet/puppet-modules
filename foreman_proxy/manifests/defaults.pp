# == Class: foreman_proxy::default
#
# Default class params
#
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
#
class foreman_proxy::defaults {
  # General Setting defaults
  $absent       = false
  $disable      = false
  $disboot      = false
  $audit_only   = false
  $restart      = true
  $version      = ''
  $template     = ''
  $source       = ''
  $options      = ''
  $my_class     = ''
  $install_options = ''
}
