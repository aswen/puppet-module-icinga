# == Class: icinga::server::packages
#
# Installs the Icinga server packages.
#
# === Authors
#
# Nedap Steppingstone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Steppingstone.
#
class icinga::server::packages (
  $p_nagios_nrpe_plugin = $::icinga::server::package_nrpe_plugin,
  $p_icinga             = $::icinga::server::package_icinga,
  $p_icinga_cgi         = $::icinga::server::package_icinga_cgi,
  $p_icinga_doc         = $::icinga::server::package_icinga_doc,
  $p_nagios_images      = $::icinga::server::package_nagios_images,
  $p_libjs_jquery_ui    = $::icinga::server::package_libjs_jquery_ui,
) {

  package { $p_nagios_nrpe_plugin:
    ensure  => latest,
  }

  package { $p_nagios_images:
    ensure  => latest,
  }

  package { [
    $p_icinga,
    $p_icinga_cgi,
    $p_icinga_doc,
    $p_libjs_jquery_ui,
  ]:
    ensure  => latest,
    notify  => Class['icinga::server::services'],
  }

}
