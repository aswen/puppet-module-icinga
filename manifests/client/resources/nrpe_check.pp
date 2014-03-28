# == Type: icinga::client::resources::nrpe_check
#
# This is a defined type used to store a nagios nrpe check
#
# === Parameters
#
# [*command*]
#   The specific params that should be included in the resource

define icinga::client::resources::nrpe_check (
  $check,
  $check_name = $title,
  $dir_nrpe   = $::icinga::client::dir_nrpe,
) {

  file { "${dir_nrpe}/${check_name}.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    require => Class['icinga::client::configs'],
    notify  => Class['icinga::client::services'],
    content => "command[${check_name}]=${check}\n",
  }

}
