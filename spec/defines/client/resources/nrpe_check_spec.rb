require 'spec_helper'

describe 'icinga::client::resources::nrpe_check' do
  let(:title) { 'check_nrpe' }
  let :params do {
    :check      => '/usr/lib/nagios/plugins/check_nrpe',
    :check_name => 'check_nrpe',
    :dir_nrpe   => '/etc/nagios/nrpe.d',
  }
  end # ends let params

  it 'should create a file with an nrpe check command in it' do
    should contain_file("#{params[:dir_nrpe]}/#{params[:check_name]}.cfg").with({
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
      :require => "Class[Icinga::Client::Configs]",
      :notify  => "Class[Icinga::Client::Services]",
    }).with_content(/^command\[#{params[:check_name]}\]=#{params[:check]}\n/)
  end # end contain file

end # ends describe
