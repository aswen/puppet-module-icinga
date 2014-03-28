require 'spec_helper'

describe 'icinga::client::services' do
  let :params do {
    :s_nrpe_server  => 'nagios-nrpe-server',
    :s_nrpe_pattern => 'nrpe',
  }
  end

  it 'should declare itself' do
    should contain_class('icinga::client::services')
  end

  it 'should manage the nrpe service' do
    should contain_service(params[:s_nrpe_server]).with({
      :ensure     => 'running',
      :pattern    => (params[:s_nrpe_pattern]),
      :enable     => true,
      :hasrestart => true,
      :restart    => "service #{params[:s_nrpe_server]} reload",
    })
  end
end
