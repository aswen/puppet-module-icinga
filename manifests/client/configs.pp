# == Class: icinga::client::configs
#
# Creates directories and drops configuration files to
# monitor a host.
#
# === Authors
#
# Nedap Steppingstone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Steppingstone.
#
class icinga::client::configs (
  $icinga_servers          = $::icinga::client::icinga_servers,
  $d_nrpe                  = $::icinga::client::dir_nrpe,
  $f_nrpe_config           = $::icinga::client::file_nrpe_config,
  $f_local_nrpe_config     = $::icinga::client::file_local_nrpe_config,
  $log_facility            = $::icinga::client::log_facility,
  $pid_file                = $::icinga::client::pid_file,
  $server_port             = $::icinga::client::server_port,
  $server_address          = $::icinga::client::server_address,
  $nrpe_user               = $::icinga::client::nrpe_user,
  $nrpe_group              = $::icinga::client::nrpe_group,
  $dont_blame_nrpe         = $::icinga::client::dont_blame_nrpe,
  $command_prefix          = $::icinga::client::command_prefix,
  $debug                   = $::icinga::client::debug,
  $command_timeout         = $::icinga::client::command_timeout,
  $connection_timeout      = $::icinga::client::connection_timeout,
  $allow_weak_random_seed  = $::icinga::client::allow_weak_random_seed,
  $f_local_nrpe_config     = $::icinga::client::file_local_nrpe_config,
  $include_dir             = $::icinga::client::include_dir,
) {

  file { $f_nrpe_config:
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('icinga/client/nrpe.cfg.erb'),
    notify  => Class['icinga::client::services'],
  }

  file { $f_local_nrpe_config:
    ensure  => present,
    mode    => '0644',
    owner   => root,
    group   => root,
  }

  file { $d_nrpe:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    force   => true,
    purge   => true,
    recurse => true,
    notify  => Class['icinga::client::services'],
  }

}
