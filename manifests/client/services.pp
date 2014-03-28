# == Class: icinga::client::services
#
# Configures the service on each host needed to monitor the machine.
#
# === Authors
#
# Nedap Steppingstone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Steppingstone.
#
class icinga::client::services (
  $s_nrpe_server  = $::icinga::client::service_nagios_nrpe_server,
  $s_nrpe_pattern = $::icinga::client::service_nagios_nrpe_server_pattern,
) {

  service { $s_nrpe_server:
    ensure     => running,
    pattern    => $s_nrpe_pattern,
    enable     => true,
    hasrestart => true,
    restart    => "service ${s_nrpe_server} reload",
  }

}
