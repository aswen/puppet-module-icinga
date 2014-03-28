require 'spec_helper'

describe 'icinga::client' do

  describe 'normal operation' do
    let :params do {
      :icinga_servers => ['1.2.3.4','2.3.4.5'],
    }
    end
    let :facts do {
      :osfamily => 'Debian',
    }
    end

    it 'should declare itself' do
      should contain_class('icinga::client')
    end

    it 'should chain child classes in the right order' do
      should contain_class('icinga::client::packages').with({:before => 'Class[Icinga::Client::Configs]',})
      should contain_class('icinga::client::configs').with({:before => 'Class[Icinga::Client::Services]'})
      should contain_class('icinga::client::services').with({:before => 'Class[Icinga::Client]'})
    end

    context 'no array of icinga servers' do
      let :params do {
        :icinga_servers => '',
      }
      end
      it 'should fail' do
        expect { subject }.to raise_error(/"" is not an Array/)
      end
    end

  end

  describe 'on unsupported' do
    let :facts do
      { :osfamily => 'Little Red Riding Hood' }
    end
    it 'should fail' do
      expect { subject }.to raise_error(/osfamily Little Red Riding Hood is not supported/)
    end
  end

end
