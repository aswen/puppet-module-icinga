# == Class: icinga::client
#
# Installs all the client side stuff we need to monitor a host.
#
# === Parameters
#
# [*icinga_servers*]
#   _default_: +empty+. Setting the icingaservers is mandatory.
#
#   Icinga servers must be an array of one or more ip address(es) or hostname(s)
#   It will be used to configure what servers are allowed to talk to the nrpe
#   daemon.
#
# === Authors
#
# Nedap Stepping Stone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Stepping Stone.
#
class icinga::client (
  $icinga_servers = '',

  $package_libnagios_perl             = $::icinga::client::params::package_libnagios_perl,
  $package_nagios_nrpe_server         = $::icinga::client::params::package_nagios_nrpe_server,
  $package_nagios_plugins_basic       = $::icinga::client::params::package_nagios_plugins_basic,
  $package_nagios_plugins_standard    = $::icinga::client::params::package_nagios_plugins_standard,
  $package_nagios_plugins_contrib     = $::icinga::client::params::package_nagios_plugins_contrib,
  $package_nagios_plugin_check_multi  = $::icinga::client::params::package_nagios_plugin_check_multi,
  $service_nagios_nrpe_server         = $::icinga::client::params::service_nagios_nrpe_server,
  $service_nagios_nrpe_server_pattern = $::icinga::client::params::service_nagios_nrpe_server_pattern,
  $dir_nagios                         = $::icinga::client::params::dir_nagios,
  $dir_nrpe                           = $::icinga::client::params::dir_nrpe,
  $file_nrpe_config                   = $::icinga::client::params::file_nrpe_config,
  $dir_nagios_lib                     = $::icinga::client::params::dir_nagios_lib,
  $dir_nagios_plugins                 = $::icinga::client::params::dir_nagios_plugins,

  # params below should equal ::icinga::server::params::$param
  $dir_icinga                         = $::icinga::client::params::dir_icinga,
  $dir_objects                        = $::icinga::client::params::dir_objects,

  $d_nrpe                 = $::icinga::client::params::dir_nrpe,
  $f_nrpe_config          = $::icinga::client::params::file_nrpe_config,
  $log_facility           = $::icinga::client::params::log_facility,
  $pid_file               = $::icinga::client::params::pid_file,
  $server_port            = $::icinga::client::params::server_port,
  $server_address         = $::icinga::client::params::server_address,
  $nrpe_user              = $::icinga::client::params::nrpe_user,
  $nrpe_group             = $::icinga::client::params::nrpe_group,
  $dont_blame_nrpe        = $::icinga::client::params::dont_blame_nrpe,
  $command_prefix         = $::icinga::client::params::command_prefix,
  $debug                  = $::icinga::client::params::debug,
  $command_timeout        = $::icinga::client::params::command_timeout,
  $connection_timeout     = $::icinga::client::params::connection_timeout,
  $allow_weak_random_seed = $::icinga::client::params::allow_weak_random_seed,
  $file_local_nrpe_config = $::icinga::client::params::file_local_nrpe_config,
  $include_dir            = $::icinga::client::params::include_dir,
) inherits icinga::client::params {

  validate_array($icinga_servers)

  class { '::icinga::client::packages': } ->
  class { '::icinga::client::configs': } ->
  class { '::icinga::client::services': } ->
  Class [ '::icinga::client' ]

}
