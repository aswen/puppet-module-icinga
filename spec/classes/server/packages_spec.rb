require 'spec_helper'

describe 'icinga::server::packages' do
  let :params do {
    :p_nagios_nrpe_plugin => 'nagios-nrpe-plugin',
    :p_icinga             => 'icinga',
    :p_icinga_cgi         => 'icinga-cgi',
    :p_icinga_doc         => 'icinga-doc',
    :p_nagios_images      => 'nagios-images',
    :p_libjs_jquery_ui    => 'libjs-jquery-ui',
  }
  end

  it 'should declare itself' do
    should contain_class('icinga::server::packages')
  end

  it 'should install nagios_nrpe_plugin' do
    should contain_package(params[:p_nagios_nrpe_plugin]).with({
      :ensure  => 'latest',
    })
  end

  it 'should install nagios_images' do
    should contain_package(params[:p_nagios_images]).with({
      :ensure  => 'latest',
    })
  end

  it 'should install icinga package' do
    should contain_package(params[:p_icinga]).with({
      :ensure  => 'latest',
      :notify  => 'Class[Icinga::Server::Services]',
    })
  end

  it 'should install icinga_cgi package' do
    should contain_package(params[:p_icinga_cgi]).with({
      :ensure  => 'latest',
      :notify  => 'Class[Icinga::Server::Services]',
    })
  end

  it 'should install icinga_doc package' do
    should contain_package(params[:p_icinga_doc]).with({
      :ensure  => 'latest',
      :notify  => 'Class[Icinga::Server::Services]',
    })
  end

  it 'should install libjs-jquery-ui package' do
    should contain_package(params[:p_libjs_jquery_ui]).with({
      :ensure  => 'latest',
      :notify  => 'Class[Icinga::Server::Services]',
    })
  end

end
