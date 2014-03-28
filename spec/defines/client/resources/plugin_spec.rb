require 'spec_helper'

describe 'icinga::client::resources::plugin' do
  let(:title) { 'check_nrpe' }
  let :params do {
    :dir_nagios_plugins => '/usr/lib/nagios/plugins/check_nrpe',
    :plugin_source      => 'check_nrpe',
  }
  end # ends let params

  it 'should create a file in the pluginsdir' do
    should contain_file("#{params[:dir_nagios_plugins]}/#{title}").with({
      :mode    => '0755',
      :owner   => 'root',
      :group   => 'root',
      :require => "Class[Icinga::Client::Configs]",
      :source  => "#{params[:plugin_source]}",
    })
  end # end contain file

end # ends describe
