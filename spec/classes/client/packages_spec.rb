require 'spec_helper'

describe 'icinga::client::packages' do
  let :params do {
    :p_libnagios_perl            => 'libnagios-plugin-perl',
    :p_nagios_nrpe_server        => 'nagios-nrpe-server',
    :p_nagios_plugins_basic      => 'nagios-plugins-basic',
    :p_nagios_plugins_standard   => 'nagios-plugins-standard',
    :p_nagios_plugins_contrib    => 'nagios-plugins-contrib',
    :p_nagios_plugin_check_multi => 'nagios-plugins-check-multi',
  }
  end

  it 'should declare itself' do
    should contain_class('icinga::client::packages')
  end

  it 'should install libnagios-plugin-perl' do
  end

  it 'should install nagios-nrpe-server' do
    should contain_package(params[:p_nagios_nrpe_server]).with({
      :ensure  => 'latest',
      :notify  => 'Class[Icinga::Client::Services]',
    })
  end

  it 'should install the other nagios plugin packages' do
    should contain_package(params[:p_libnagios_perl]).with({
      :ensure  => 'latest',
    })
    should contain_package(params[:p_nagios_plugins_basic]).with({
      :ensure  => 'latest',
    })
    should contain_package(params[:p_nagios_plugins_standard]).with({
      :ensure  => 'latest',
    })
    should contain_package(params[:p_nagios_plugins_contrib]).with({
      :ensure  => 'latest',
    })
    should contain_package(params[:p_nagios_plugin_check_multi]).with({
      :ensure  => 'latest',
    })
  end

end
