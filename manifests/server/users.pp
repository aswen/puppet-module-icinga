class icinga::server::users {

  user { 'nagios':
    ensure => present,
    system => true,
  }

}
