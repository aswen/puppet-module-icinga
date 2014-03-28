require 'spec_helper'

describe 'icinga::server::users' do

  it 'should declare itself' do
    should contain_class('icinga::server::users')
  end

  it 'should create a user nagios' do
    should contain_user('nagios').with({
      :ensure => 'present',
      :system => true,
    })
  end
end
