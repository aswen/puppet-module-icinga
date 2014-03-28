<!--- vim: set autoindent smartindent textwidth=80 : -->

#icinga
This is the icinga module.

##Basic usage
This module manages both Icinga servers and servers monitored by Icinga

###Server
It should be included on any host that needs icinga server:

```puppet
class { '::icinga::server': }
```
All configuration of icinga.cfg and cgi.cfg is parameterized in
::icinga::server::params. You can override every param you like.

```puppet
class { '::icinga::server':
  enable_notifications => false,
  ...
}
```

###Client
The client module installs nagios_nrpe on a host and allows the array of
icingaservers to connect to the nrpe daemon.
Therefor this param should be included on any host that needs to be monitored by
an icinga server:

```puppet
class { '::icinga::client':
  icinga_servers => 'ips of servers',
}
```
_note: that icinga_servers might be set via hiera as well_
By default a nrpe.cfg is installed without any checks defined. You have to add
them like so:

```puppet
::icinga::client::resources::nrpe_check { 'check_load':
  check => "${dir_nagios_plugins}/check_load -w ${load_warn} -c ${load_crit}",
}
```
The same way you can add a plugin to a server:

```puppet
::icinga::client::resources::plugin { 'check_uptime':
  plugin_source  => 'puppet:///modules/profile/nedap/icinga/client/nrpe_plugins/check_uptime',
}
::icinga::client::resources::nrpe_check { 'check_uptime':
  check => "${dir_nagios_plugins}/check_uptime",
}
```

##Icinga configuration
Once you have installed the icinga module on your server you should have an empty
server. That is, there are no hosts or services defined.

###Directly on server
So, in order to make it testing anything you should add hosts, contacts,
timeperiods, services, etc. Because of keeping any data out of a module as a
rule of thumb this is _not done in this_ module but from outside
of it. We use a separate profile module for this.
All resources that are available in nagios/icinga are available in the resource
templates in this module. That means you have to follow the guidelines from the
[icinga objects documentation](http://docs.icinga.org/latest/en/objectdefinitions.html).

This you can define a host like so:

```puppet
::icinga::resource { 'name':
  type          => 'host',
  icinga_config => {
    address     => 'ipaddress or hostname',
    icon_image  => 'bla.png',
    ...
  },
}
```
and a service like so:

```puppet
::icinga::resource { 'name':
  type                => 'service',
  icinga_config       => {
    servicegroups     => 'list of servicegroups',
    contactgroup_name => 'admins',
    ...
  },
}
```
Icinga::resource uses a template (templates/resource.erb) that has some logic
in it but it leaves it completely to the user to create correct config stanza's
that are inserted in $dir_icinga/objects/$type.cfg. This way any changes to
nagios/icinga's object configuration parameters can be used without any change
in this module.
The erb sets a few defaults though that can be easily overriden. For example,
when you define a host without inserting name in the hash "icinga_config" then
the erb will take $title as name. Same goes for host_name and address.
The erb _will not_ do any validation on configuration objects.
This creates a host and a service resource on the icinga server. That's usefull
for defining services and hosts that don't run puppet. But hosts you want
to monitor that do run puppet you can use the client module. (This requires
stored_configs => true BTW). In that case the client stores a host resource in
the puppet backend and then the Icinga server will realize all those resources.
TIP: to keep the run of a puppet agent as short as possible only use this as
little as you can.

```puppet
::icinga::resource { 'monitoringserver':
  type             => 'host',
  icinga_config    => {
    use            => 'generic server',
    address        => 'monitoringserver.example.com',
    hostgroups     => '+icingaservers',
    contact_groups => '+admins'
  },
}
```

Whatever you do, the result will be a file in /etc/icinga/objects called
${type}.cfg, for example: host.cfg.
That file will look like so:
```nagios
define host {
  use            generic server
  host_name      monitoringserver
  address        monitoringserver.example.com
  hostgroups     +icingaservers
  contact_groups +admins
}
```

###Exporting client configs
It would be a way to tedious job to create config stanza's like above for each
server in an environment so you can take advantage of Puppets exported resource
feature. You can then add a stanza like this to the configuration of a machine
that needs to be monitored:

```puppet
@@::icinga::resource { $::hostname:
  type             => 'host',
  icinga_config    => {
    use            => 'generic server',
    address        => 'bla.example.com',
    hostgroups     => '+webservers',
    contact_groups => '+admins'
  },
}
@@::icinga::resource { "${::hostname} disks":
  type                    => 'service',
  icinga_config           => {
    use                   => 'disks',
    host_name             => $::hostname,
    notifications_enabled => $icinga_notifications_enabled,
    service_description   => 'disks', # This is here because the erb would
                                      # insert "$::hostname disks" here as it
                                      # takes $title if service_description is
                                      # unset.
  },
}
```

##Icinga webserver configuration (optional)
This module offers the creation of an example vhost config in the icinga config
dir that van conveniently be symlinked into a sites-enabled dir of either ngix
or apache2.
To take advantage of this feature expand the icinga::server stanza as follows:
```puppet
icinga::server { 'monitoring server':
  icinga_configure_webserver  => true,
  icinga_webserver            => 'apache2', #default
  icinga_webserver_port       => '9000', #default
  icinga_vhostname            => 'monitor.example.com',
}
```
Or, if you prefer nginx:
```puppet
icinga::server { 'monitoring server':
  icinga_configure_webserver  => true,
  icinga_webserver            => 'nginx',
  icinga_webserver_port       => '9000', #default
  icinga_vhostname            => 'monitor.example.com',
}
```
Once you did this there will be a file
/etc/icinga/monitor.example.com-{apache2,ngix}.conf.example that holds a basic
config that should works for most situations. However, in each case have look at
the comments in the beginning of these files before enabling them. Both
webservers have some prerequisits that need to be taken care of.
If that's done you can link the conf file into the apropriate sites-enabled dir
of the webserver.

##Requirements
The use of this module involves some preparation:

###Packages
You might consider to use the puppetlabs apt module to pin icinga to backports.
Backports has way newer versions of Icinga. This module is developed with
portability in mind. Yet I only used Debian (Wheezy) to develop and test on so I
didn't found any time to extend config for other popular distro's. It should be
easy to add the correct config to params though.

Packages are otherwise found in:
Debian wheezy:
  - nagios-images
  - nagios-nrpe-plugin
  - libnagios-plugin-perl
  - nagios-nrpe-server

Debian wheezy-backports:
  - icinga
  - icinga-cgi
  - nagios-plugins-basic
  - nagios-plugins-common
  - nagios-plugins-contrib
  - nagios-plugin-check-multi
  - libjs-jquery-ui

###Puppet
You need the following at hand within your Puppet environment:
- exported resources enabled
- stdlib [https://forge.puppetlabs.com/puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
- concat_native [https://forge.puppetlabs.com/theforeman/concat_native](https://forge.puppetlabs.com/theforeman/concat_native)
We also recommend puppetlabs' apt module:
[https://forge.puppetlabs.com/puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)

##License
Copyright 2012, 2013 Nedap Steppingstone.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

&nbsp;&nbsp;&nbsp;&nbsp;[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

##Support
Nedap Steppingstone

##TODO
This module can be improved:
- I want to add a submodule for those who want to install icinga-web
- I need to create something to manage custom html and css files.
- I need to create some example files that make a set of default tests.
- I want to add nagios graph support
