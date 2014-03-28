# == Class: icinga::client::packages
#
# Installs all the client side stuff we need to monitor a host.
#
# === Authors
#
# Nedap Steppingstone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Steppingstone.
#
class icinga::client::packages (
  $p_libnagios_perl            = $::icinga::client::package_libnagios_perl,
  $p_nagios_nrpe_server        = $::icinga::client::package_nagios_nrpe_server,
  $p_nagios_plugins_basic      = $::icinga::client::package_nagios_plugins_basic,
  $p_nagios_plugins_standard   = $::icinga::client::package_nagios_plugins_standard,
  $p_nagios_plugins_contrib    = $::icinga::client::package_nagios_plugins_contrib,
  $p_nagios_plugin_check_multi = $::icinga::client::package_nagios_plugin_check_multi,
) {

  package { $p_nagios_nrpe_server:
    ensure => latest,
    notify => Class['icinga::client::services'],
  }

  package { [
    $p_libnagios_perl,
    $p_nagios_plugins_basic,
    $p_nagios_plugins_standard,
    $p_nagios_plugins_contrib,
    $p_nagios_plugin_check_multi,
  ]:
    ensure  => latest,
  }

}
