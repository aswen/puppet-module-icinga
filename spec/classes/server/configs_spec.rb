require 'spec_helper'

describe 'icinga::server::configs' do

  d_icinga = '/etc/icinga'
  let :default_params do {
    :d_icinga                   => d_icinga,
    :d_objects                  => "#{d_icinga}/objects",
    :d_htdocs                   => '/usr/share/icinga/htdocs',
    :d_cgi                      => '/usr/lib/cgi-bin/icinga',
    :d_stylesheets              => "#{d_icinga}/stylesheets",
    :f_htpasswd                 => "#{d_icinga}/htpasswd.users",
    :f_icingacfg                => "#{d_icinga}/icinga.cfg",
    :f_resourcecfg              => "#{d_icinga}/resource.cfg",
    :f_cgicfg                   => "#{d_icinga}/cgi.cfg",
    :d_nagios_plugins           => '/usr/lib/nagios/plugins',
    :d_icinga_plugins           => '/usr/share/icinga/scripts',
    :d_icinga_eventhandlers     => '/usr/share/icinga/plugins/eventhandlers',
    :d_icinga_cache             => '/var/cache/icinga',
    :enable_notifications       => '1',
    :icinga_configure_webserver => true,
    :icinga_vhostname           => 'monitor.example.com',
    :icinga_webserver           => 'apache2',
    :icinga_webserver_port      => 9000,
    :icinga_user                => 'nagios',
    :icinga_group               => 'nagios',
    :webserver_group            => 'www-data',
  }
  end #default params

  let :params do {}.merge(default_params)
  end #merge

  it 'should declare itself' do
    should contain_class('icinga::server::configs')
  end #declare itself

  it 'dir_icinga should manage the entire configdir' do
    should contain_file(params[:d_icinga]).with({
      :ensure  => 'directory',
      :mode    => '0755',
      :owner   => 'root',
      :group   => 'root',
      :recurse => 'true',
      :purge   => 'true',
      :notify  => "Class[Icinga::Server::Services]",
    })
  end #dir_icinga should manage the entire configdir

  it 'dir_stylesheets should manage the stylesheetsdir' do
    should contain_file(params[:d_stylesheets]).with({
      :ensure  => 'directory',
      :mode    => '0755',
      :owner   => 'root',
      :group   => 'root',
    })
  end #dir_stylesheets should manage the stylesheetsdir

  it 'file_icingacfg should manage the icinga.cfg file' do
    should contain_file(params[:f_icingacfg]).with({
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
      :notify  => "Class[Icinga::Server::Services]",
    })
  end #file_icingacfg should manage the icinga.cfg file

  it 'file_cgicfg should manage the cgi.cfg file' do
    should contain_file(params[:f_cgicfg]).with({
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
      :notify  => "Class[Icinga::Server::Services]",
    })
  end #file_cgicfg should manage the cgi.cfg file

  it 'dir_objects should manage the objectsdir' do
    should contain_file(params[:d_objects]).with({
      :ensure  => 'directory',
      :mode    => '0755',
      :owner   => 'root',
      :group   => 'root',
      :recurse => 'true',
      :purge   => 'true',
      :notify  => "Class[Icinga::Server::Services]",
    })
  end #dir_objects should manage the objectsdir

  it 'dir_icinga_plugins should manage the pluginsdir' do
    should contain_file(params[:d_icinga_plugins]).with({
      :ensure  => 'directory',
      :mode    => '0755',
      :owner   => 'root',
      :group   => 'root',
      :recurse => 'true',
      :purge   => 'true',
      :notify  => "Class[Icinga::Server::Services]",
    })
  end #dir_icinga_plugins should manage the pluginsdir

  # begin resource.cfg
  it 'should setup resource.cfg' do
    should contain_file(params[:f_resourcecfg]).with({
      :mode  => '0600',
      :owner => 'nagios',
      :group => 'root',
      :source => /icinga_resourceconf/,
    })
  end #should setup resource.cfg

  it 'should concat_build icinga_resourceconf' do
    should contain_concat_build('icinga_resourceconf').with({
      :order => ['*.conf']
    })
  end #should concat_build icinga_resourceconf

  it 'should generate the start' do
    should contain_concat_fragment('icinga_resourceconf+001-start.conf').with_content(
      /\$USER1\$=#{params[:d_nagios_plugins]}/
    ).with_content(
      /\$USER2\$=#{params[:d_icinga_plugins]}/
    ).with_content(
      /\$USER3\$=#{params[:d_icinga_eventhandlers]}/
    )
  end #should generate the start
  # end resource.cfg

  # begin htpasswd
  it 'should setup htpasswd' do
    should contain_file(params[:f_htpasswd]).with({
      :mode  => '0644',
      :owner => 'root',
      :group => 'root',
      :source => /icinga_htpasswd/,
    })
  end #should setup htpasswd

  it 'should concat_build icinga_htpasswd' do
    should contain_concat_build('icinga_htpasswd').with({
      :order => ['*.conf']
    })
  end #should concat_build icinga_htpasswd

  it 'should generate the start' do
    should contain_concat_fragment('icinga_htpasswd+001-start.conf').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end htpasswd

  it 'create example webserverconfig file /etc/icinga/monitor.example.com-apache2.conf.example' do
    should contain_file("#{params[:d_icinga]}/#{params[:icinga_vhostname]}-#{params[:icinga_webserver]}.conf.example").with({
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
    }).with_content(
      /^<VirtualHost #{params[:icinga_vhostname]}:#{params[:icinga_webserver_port]}>/
    ).with_content(
      /^  ScriptAlias \/cgi-bin\/icinga #{params[:d_cgi]}/
    ).with_content(
      /^  Alias \/stylesheets #{params[:d_stylesheets]}/
    ).with_content(
      /^  DocumentRoot #{params[:d_htdocs]}/
    ).with_content(
      /^    AuthUserFile #{params[:f_htpasswd]}/
    )
  end # create example webserverconfig file /etc/icinga/monitor.example.com-apache2.conf.example

  context 'unsupported webserver' do
    let :other_params do {
      :icinga_webserver => 'nginx',
    }
    end #other_params
    let :params do {}.merge(default_params).merge(other_params)
    end #merge
    it 'create example webserverconfig file /etc/icinga/monitor.example.com-nginx.conf.example' do
      should contain_file("#{params[:d_icinga]}/#{params[:icinga_vhostname]}-#{params[:icinga_webserver]}.conf.example").with({
        :mode    => '0644',
        :owner   => 'root',
        :group   => 'root',
      }).with_content(
        /^  server_name #{params[:icinga_vhostname]};/
      ).with_content(
        /^    alias #{params[:d_stylesheets]}/
      ).with_content(
        /^    root #{params[:d_htdocs]}/
      ).with_content(
        /^  auth_basic_user_file #{params[:f_htpasswd]}/
      )
    end #create example webserverconfig file /etc/icinga/monitor.example.com-nginx.conf.example
  end #context unsupported webserver

  context 'check_external_commands' do
    let :facts do {
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
    }
    end #facts
    #let(:pre_condition) {
    #  [
    #    "include icinga::server"
    #  ]
    #}
    let :other_params do {
      :check_external_commands => 1,
    }
    end #other_params
    let :params do {}.merge(default_params).merge(other_params)
    end #merge
    it 'should exec dpkg-icinga-override /var/lib/icinga' do
      should contain_exec('dpkg-icinga-override /var/lib/icinga').with({
        :command => 'dpkg-statoverride --update --add nagios nagios 751 /var/lib/icinga',
        :path    => '/usr/sbin',
        :unless  => 'dpkg-statoverride --list nagios nagios 751 /var/lib/icinga',
      })
    end #should exec dpkg-icinga-override /var/lib/icinga
    it 'should exec dpkg-icinga-override /var/lib/icinga/rw' do
      should contain_exec('dpkg-icinga-override /var/lib/icinga/rw').with({
        :command => 'dpkg-statoverride --update --add nagios www-data 2710 /var/lib/icinga/rw',
        :path    => '/usr/sbin',
        :unless  => 'dpkg-statoverride --list nagios www-data 2710 /var/lib/icinga/rw',
      })
    end #should exec dpkg-icinga-override /var/lib/icinga/rw
  end #context check external commands

  # begin command.cfg
  it 'should setup command.cfg' do
    should contain_file("#{params[:d_objects]}/command.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_command/,
    })
  end #should setup command file

  it 'should concat_build icinga_command' do
    should contain_concat_build('icinga_command').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_command

  it 'should generate the start' do
    should contain_concat_fragment('icinga_command+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end command

  # begin contact.cfg
  it 'should setup contact.cfg' do
    should contain_file("#{params[:d_objects]}/contact.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_contact/,
    })
  end #should setup contact file

  it 'should concat_build icinga_contact' do
    should contain_concat_build('icinga_contact').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_contact

  it 'should generate the start' do
    should contain_concat_fragment('icinga_contact+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end contact

  # begin contactgroup.cfg
  it 'should setup contactgroup.cfg' do
    should contain_file("#{params[:d_objects]}/contactgroup.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_contactgroup/,
    })
  end #should setup contactgroup file

  it 'should concat_build icinga_contactgroup' do
    should contain_concat_build('icinga_contactgroup').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_contactgroup

  it 'should generate the start' do
    should contain_concat_fragment('icinga_contactgroup+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end contactgroup

  # begin host.cfg
  it 'should setup host.cfg' do
    should contain_file("#{params[:d_objects]}/host.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_host/,
    })
  end #should setup host file

  it 'should concat_build icinga_host' do
    should contain_concat_build('icinga_host').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_host

  it 'should generate the start' do
    should contain_concat_fragment('icinga_host+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end host

  # begin hostdependency.cfg
  it 'should setup hostdependency.cfg' do
    should contain_file("#{params[:d_objects]}/hostdependency.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_hostdependency/,
    })
  end #should setup hostdependency file

  it 'should concat_build icinga_hostdependency' do
    should contain_concat_build('icinga_hostdependency').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_hostdependency

  it 'should generate the start' do
    should contain_concat_fragment('icinga_hostdependency+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end hostdependency

  # begin hostescalation.cfg
  it 'should setup hostescalation.cfg' do
    should contain_file("#{params[:d_objects]}/hostescalation.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_hostescalation/,
    })
  end #should setup hostescalation file

  it 'should concat_build icinga_hostescalation' do
    should contain_concat_build('icinga_hostescalation').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_hostescalation

  it 'should generate the start' do
    should contain_concat_fragment('icinga_hostescalation+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end hostescalation

  # begin hostextinfo.cfg
  it 'should setup hostextinfo.cfg' do
    should contain_file("#{params[:d_objects]}/hostextinfo.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_hostextinfo/,
    })
  end #should setup hostextinfo file

  it 'should concat_build icinga_hostextinfo' do
    should contain_concat_build('icinga_hostextinfo').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_hostextinfo

  it 'should generate the start' do
    should contain_concat_fragment('icinga_hostextinfo+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end hostextinfo

  # begin hostgroup.cfg
  it 'should setup hostgroup.cfg' do
    should contain_file("#{params[:d_objects]}/hostgroup.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_hostgroup/,
    })
  end #should setup hostgroup file

  it 'should concat_build icinga_hostgroup' do
    should contain_concat_build('icinga_hostgroup').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_hostgroup

  it 'should generate the start' do
    should contain_concat_fragment('icinga_hostgroup+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end hostgroup

  # begin module.cfg
  it 'should setup module.cfg' do
    should contain_file("#{params[:d_objects]}/module.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_module/,
    })
  end #should setup module file

  it 'should concat_build icinga_module' do
    should contain_concat_build('icinga_module').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_module

  it 'should generate the start' do
    should contain_concat_fragment('icinga_module+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end module

  # begin service.cfg
  it 'should setup service.cfg' do
    should contain_file("#{params[:d_objects]}/service.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_service/,
    })
  end #should setup service file

  it 'should concat_build icinga_service' do
    should contain_concat_build('icinga_service').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_service

  it 'should generate the start' do
    should contain_concat_fragment('icinga_service+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end service

  # begin servicedependency.cfg
  it 'should setup servicedependency.cfg' do
    should contain_file("#{params[:d_objects]}/servicedependency.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_servicedependency/,
    })
  end #should setup servicedependency file

  it 'should concat_build icinga_servicedependency' do
    should contain_concat_build('icinga_servicedependency').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_servicedependency

  it 'should generate the start' do
    should contain_concat_fragment('icinga_servicedependency+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end servicedependency

  # begin serviceescalation.cfg
  it 'should setup serviceescalation.cfg' do
    should contain_file("#{params[:d_objects]}/serviceescalation.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_serviceescalation/,
    })
  end #should setup serviceescalation file

  it 'should concat_build icinga_serviceescalation' do
    should contain_concat_build('icinga_serviceescalation').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_serviceescalation

  it 'should generate the start' do
    should contain_concat_fragment('icinga_serviceescalation+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end serviceescalation

  # begin serviceextinfo.cfg
  it 'should setup serviceextinfo.cfg' do
    should contain_file("#{params[:d_objects]}/serviceextinfo.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_serviceextinfo/,
    })
  end #should setup serviceextinfo file

  it 'should concat_build icinga_serviceextinfo' do
    should contain_concat_build('icinga_serviceextinfo').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_serviceextinfo

  it 'should generate the start' do
    should contain_concat_fragment('icinga_serviceextinfo+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end serviceextinfo

  # begin servicegroup.cfg
  it 'should setup servicegroup.cfg' do
    should contain_file("#{params[:d_objects]}/servicegroup.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_servicegroup/,
    })
  end #should setup servicegroup file

  it 'should concat_build icinga_servicegroup' do
    should contain_concat_build('icinga_servicegroup').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_servicegroup

  it 'should generate the start' do
    should contain_concat_fragment('icinga_servicegroup+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end servicegroup

  # begin timeperiod.cfg
  it 'should setup timeperiod.cfg' do
    should contain_file("#{params[:d_objects]}/timeperiod.cfg").with({
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root',
      :notify => "Class[Icinga::Server::Services]",
      :source => /icinga_timeperiod/,
    })
  end #should setup timeperiod file

  it 'should concat_build icinga_timeperiod' do
    should contain_concat_build('icinga_timeperiod').with({
      :order => ['*.cfg']
    })
  end #should concat_build icinga_timeperiod

  it 'should generate the start' do
    should contain_concat_fragment('icinga_timeperiod+001-start.cfg').with_content(
      /# This file is maintained by Puppet\.\n/
    )
  end #should generate the start
  # end timeperiod

end
