require 'spec_helper'

describe 'icinga::resource' do

  let(:title) { 'monitoringserver' }

  describe 'normal operation' do

    context 'type is no string' do
      let :params do {
        :type => true,
      }
      end # params
      it 'should fail' do
        expect { subject }.to raise_error(/true is not a string/)
      end # should fail
    end # type is no string

    context 'icinga_config is no hash' do
      let :params do {
        :type          => 'host',
        :icinga_config => 'no hash',
      }
      end # params
      it 'should fail' do
        expect { subject }.to raise_error(/"no hash" is not a Hash/)
      end # should fail
    end # icinga_config no hash

    # In this case the erb template should fill in the gaps
    context 'create a host with only minimal arguments' do
      let :params do {
        :type          => 'host',
        :icinga_config => {
          'use'        => 'generic host',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  host_name      #{title}$/).
          with_content(/^  use            #{params[:icinga_config]['use']}$/).
          with_content(/^  name           #{title}$/).
          with_content(/^  address        #{title}$/).
          with_content(/^  icon_image_alt #{title.capitalize}$/).
          with_content(/^  alias          #{title}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with minimal args

    # In this case not title but alias should be the contents of icon_image_alt
    context 'create a host with alias set' do
      let :params do {
        :type          => 'host',
        :icinga_config => {
          'alias'      => 'this is a more descriptive alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  host_name      #{title}$/).
          with_content(/^  name           #{title}$/).
          with_content(/^  address        #{title}$/).
          with_content(/^  icon_image_alt #{params[:icinga_config]['alias'].capitalize}$/).
          with_content(/^  alias          #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with alias value in icon_image_alt

    # In this case the icon_image_alt should not be changes by the erb
    context 'create a host with alias and icon_image_alt set' do
      let :params do {
        :type              => 'host',
        :icinga_config     => {
          'alias'          => 'this is a more descriptive alias',
          'icon_image_alt' => 'this is a text that pops up when mouse goes over icon_image',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  host_name      #{title}$/).
          with_content(/^  name           #{title}$/).
          with_content(/^  address        #{title}$/).
          with_content(/^  icon_image_alt #{params[:icinga_config]['icon_image_alt']}$/).
          with_content(/^  alias          #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with alias and icon_image_alt set

    # In this case the erb should not touch any param
    context 'create a host with all params set' do
      let :params do {
        :type              => 'host',
        :icinga_config     => {
          'name'           => 'monitoringserver',
          'host_name'      => 'monitoringserver',
          'address'        => 'monitoringserver.example.com',
          'icon_image_alt' => 'this is a text that pops up when mouse goes over icon_image',
          'alias'          => 'this is a more descriptive alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name           #{params[:icinga_config]['name']}$/).
          with_content(/^  host_name      #{params[:icinga_config]['host_name']}$/).
          with_content(/^  address        #{params[:icinga_config]['address']}$/).
          with_content(/^  icon_image_alt #{params[:icinga_config]['icon_image_alt']}$/).
          with_content(/^  alias          #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with all params set

    # In this case the erg template should fill in the gaps
    context 'create a service with minimal args' do
      let :params do {
        :type          => 'service',
        :icinga_config => {
          'register'   => '0',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name                #{title}$/).
          with_content(/^  icon_image_alt      #{title.capitalize}$/).
          with_content(/^  display_name        #{title.capitalize}$/).
          with_content(/^  service_description #{title}$/).
          with_content(/^  register            #{params[:icinga_config]['register']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a service with minimal arguments

    # In this case icon_image_alt and displayname should service_description.capitalize
    context 'create a service with service_description set' do
      let :params do {
        :type                   => 'service',
        :icinga_config          => {
          'service_description' => 'this is the identifier of the service',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name                #{title}$/).
          with_content(/^  icon_image_alt      #{params[:icinga_config]['service_description'].capitalize}$/).
          with_content(/^  display_name        #{params[:icinga_config]['service_description'].capitalize}$/).
          with_content(/^  service_description #{params[:icinga_config]['service_description']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a service with service_description set

    # In this case the erb should not touch any param
    context 'create a service with all args set' do
      let :params do {
        :type                   => 'service',
        :icinga_config          => {
          'name'                => 'this should contain the name',
          'display_name'        => 'this should contain a friendly name',
          'service_description' => 'this is the identifier of the service',
          'icon_image_alt'      => 'this is a text that pops up when mouse goes over icon_image',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name                #{params[:icinga_config]['name']}$/).
          with_content(/^  icon_image_alt      #{params[:icinga_config]['icon_image_alt']}$/).
          with_content(/^  display_name        #{params[:icinga_config]['display_name']}$/).
          with_content(/^  service_description #{params[:icinga_config]['service_description']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a service with all arguments

    # In this case the erb should contain a hostdependency with name=title
    context 'create a hostdependency with name=title' do
      let :params do {
        :type          => 'hostdependency',
        :icinga_config => {
          'use'        => 'this should contain some template',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name #{title}$/).
          with_content(/^  use  #{params[:icinga_config]['use']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a hostdependency with minimal args

    # In this case the erb should contain a hostdependency with its own name
    context 'create a hostdependency with its own name' do
      let :params do {
        :type          => 'hostdependency',
        :icinga_config => {
          'name'       => 'this should contain the name',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name #{params[:icinga_config]['name']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a hostdependency with its own name

    # In this case the erb should contain a hostgroup with hostgroupname set as
    # title.
    context 'create a hostgroup with its hostgroupname as title' do
      let :params do {
        :type          => 'hostgroup',
        :icinga_config => {
          'alias'      => 'this should contain some alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  hostgroup_name #{title}$/).
          with_content(/^  alias          #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a hostgroup with hostgroupname as title.

    # In this case the erb should contain a hostgroup with alias set as
    # title.capitalize.
    context 'create a hostgroup with its alias as title' do
      let :params do {
        :type              => 'hostgroup',
        :icinga_config     => {
          'hostgroup_name' => 'this should contain a hostgroup name',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  hostgroup_name #{params[:icinga_config]['hostgroup_name']}$/).
          with_content(/^  alias          #{title.capitalize}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a hostgroup with alias as title

    # In this case the erb should contain a hostgroup with all params set
    context 'create a hostgroup with all params set' do
      let :params do {
        :type              => 'hostgroup',
        :icinga_config     => {
          'hostgroup_name' => 'this should contain a hostgroup name',
          'alias'          => 'this should contain some alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  hostgroup_name #{params[:icinga_config]['hostgroup_name']}$/).
          with_content(/^  alias          #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a hostgroup with all params set

    # In this case the erb should contain a servicegroup with servicegroupname set as
    # title.
    context 'create a servicegroup with its servicegroupname as title' do
      let :params do {
        :type          => 'servicegroup',
        :icinga_config => {
          'alias'      => 'this should contain some alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  servicegroup_name #{title}$/).
          with_content(/^  alias             #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a servicegroup with servicegroupname as title.

    # In this case the erb should contain a servicegroup with alias set as
    # title.capitalize.
    context 'create a servicegroup with its alias as title' do
      let :params do {
        :type                 => 'servicegroup',
        :icinga_config        => {
          'servicegroup_name' => 'this should contain a servicegroup name',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  servicegroup_name #{params[:icinga_config]['servicegroup_name']}$/).
          with_content(/^  alias             #{title.capitalize}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a servicegroup with alias as title

    # In this case the erb should contain a servicegroup with all params set
    context 'create a servicegroup with all params set' do
      let :params do {
        :type                 => 'servicegroup',
        :icinga_config        => {
          'servicegroup_name' => 'this should contain a servicegroup name',
          'alias'             => 'this should contain some alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  servicegroup_name #{params[:icinga_config]['servicegroup_name']}$/).
          with_content(/^  alias             #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a servicegroup with all params set

    # In this case the erb should contain a contactgroup with contactgroupname set as
    # title.
    context 'create a contactgroup with its contactgroupname as title' do
      let :params do {
        :type          => 'contactgroup',
        :icinga_config => {
          'alias'      => 'this should contain some alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  contactgroup_name #{title}$/).
          with_content(/^  alias             #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a contactgroup with contactgroupname as title.

    # In this case the erb should contain a contactgroup with alias set as
    # title.capitalize.
    context 'create a contactgroup with its alias as title' do
      let :params do {
        :type                 => 'contactgroup',
        :icinga_config        => {
          'contactgroup_name' => 'this should contain a contactgroup name',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  contactgroup_name #{params[:icinga_config]['contactgroup_name']}$/).
          with_content(/^  alias             #{title.capitalize}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a contactgroup with alias as title

    # In this case the erb should contain a contactgroup with all params set
    context 'create a contactgroup with all params set' do
      let :params do {
        :type                 => 'contactgroup',
        :icinga_config        => {
          'contactgroup_name' => 'this should contain a contactgroup name',
          'alias'             => 'this should contain some alias',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  contactgroup_name #{params[:icinga_config]['contactgroup_name']}$/).
          with_content(/^  alias             #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a contactgroup with all params set

    # In this case the erb should contain a command with the commandname as title.
    context 'create a cmmand with the commandname as title' do
      let :params do {
        :type            => 'command',
        :icinga_config   => {
          'command_line' => 'this should contain a commandline',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  command_name #{title}$/).
          with_content(/^  command_line #{params[:icinga_config]['command_line']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a command with commandname as title

    # In this case the erb should contain a command with all params set
    context 'create a cmmand with all params set' do
      let :params do {
        :type            => 'command',
        :icinga_config   => {
          'command_name' => 'this should contain a command',
          'command_line' => 'this should contain a commandline',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  command_name #{params[:icinga_config]['command_name']}$/).
          with_content(/^  command_line #{params[:icinga_config]['command_line']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a command with commandname as title

    # In this case the erb template should fill in the gaps
    context 'create a contact with only minimal arguments' do
      let(:title) { 'john luther' }
      let :params do {
        :type          => 'contact',
        :icinga_config => {
          'use'        => 'default_contact',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  contact_name #{title}$/).
          with_content(/^  use          #{params[:icinga_config]['use']}$/).
          with_content(/^  name         #{title}$/).
          with_content(/^  alias        #{title.split(" ").map(&:capitalize).join(" ")}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with minimal args

    # In this case the erb template should use the params given
    context 'create a contact with all arguments' do
      let(:title) { 'john luther' }
      let :params do {
        :type            => 'contact',
        :icinga_config   => {
          'contact_name' => 'John Luther',
          'name'         => 'Alice Morgan',
          'alias'        => 'Ds Ripley',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name         #{params[:icinga_config]['name']}$/).
          with_content(/^  contact_name #{params[:icinga_config]['contact_name']}$/).
          with_content(/^  alias        #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with minimal args

    # In this case the erb template should fill in the gaps
    context 'create a timeperiod with only minimal arguments' do
      let(:title) { '24x7' }
      let :params do {
        :type          => 'timeperiod',
        :icinga_config => {
          'use'        => 'default_timeperiod',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  timeperiod_name #{title}$/).
          with_content(/^  use             #{params[:icinga_config]['use']}$/).
          with_content(/^  name            #{title}$/).
          with_content(/^  alias           #{title.capitalize}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with minimal args

    # In this case the erb template should use the params given
    context 'create a timeperiod with all arguments' do
      let(:title) { 'workhours' }
      let :params do {
        :type               => 'timeperiod',
        :icinga_config      => {
          'timeperiod_name' => 'workhours',
          'name'            => 'workhours',
          'alias'           => 'Office hours',
        }
      } end # params
      it 'contain a concat fragment' do
        should contain_concat_fragment("icinga_#{params[:type]}+#{title}.cfg").
          with_content(/^define #{params[:type]} {$/).
          with_content(/^  name            #{params[:icinga_config]['name']}$/).
          with_content(/^  timeperiod_name #{params[:icinga_config]['timeperiod_name']}$/).
          with_content(/^  alias           #{params[:icinga_config]['alias']}$/).
          with_content(/^}$/)
      end # contain concat fragment
    end # create a host with minimal args

  end # end normal operation

end
