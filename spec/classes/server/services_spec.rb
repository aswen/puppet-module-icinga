require 'spec_helper'

describe 'icinga::server::services' do
  let :params do {
    :s_icinga => 'icinga',
  }
  end

  it 'should declare itself' do
    should contain_class('icinga::server::services')
  end

  it 'should manage the icinga service' do
    should contain_service(params[:s_icinga]).with({
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :restart    => 'service icinga reload',
      :hasstatus  => true,
    })
  end
end
