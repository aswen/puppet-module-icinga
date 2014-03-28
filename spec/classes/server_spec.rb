require 'spec_helper'

# I should create a test fpr realizing the files with tags icinga_config here

describe 'icinga::server' do

  describe 'normal operation' do
    let :default_params do {
      :enable_notifications       => true,
      :icinga_configure_webserver => true,
      :icinga_vhostname           => 'monitor.example.com',
      :icinga_webserver           => 'apache2',
      :icinga_webserver_port      => 9000,
    }
    end
    let :facts do {
      :osfamily => 'Debian',
    }
    end

    let :params do {}.merge(default_params) end

    it 'should declare itself' do
      should contain_class('icinga::server')
    end

    context 'no bool set on enable_notifications' do
      let :faulty_params do {
        :enable_notifications => 'nobool',
      }
      end
      let :params do {}.merge(default_params).merge(faulty_params)
      end
      it 'should fail' do
        expect { subject }.to raise_error(/"nobool" is not a boolean/)
      end
    end

    context 'no bool set on icinga_configure_webserver' do
      let :faulty_params do {
        :icinga_configure_webserver => 'nobool',
      }
      end
      let :params do {}.merge(default_params).merge(faulty_params)
      end
      it 'should fail' do
        expect { subject }.to raise_error(/"nobool" is not a boolean/)
      end
    end

    context 'icinga_vhostname not a string' do
      let :faulty_params do {
        :icinga_vhostname           => true,
      }
      end
      let :params do {}.merge(default_params).merge(faulty_params)
      end
      it 'should fail' do
        expect { subject }.to raise_error(/true is not a string/)
      end
    end

    context 'no icinga_vhostname set' do
      let :faulty_params do {
        :icinga_vhostname => '',
      }
      end
      let :params do {}.merge(default_params).merge(faulty_params)
      end
      it 'should fail' do
        expect { subject }.to raise_error(/You should tell me the hostname to configure./)
      end
    end

    context 'unsupported webserver' do
      let :faulty_params do {
        :icinga_webserver => 'lighttpd',
      }
      end
      let :params do {}.merge(default_params).merge(faulty_params)
      end
      it 'should fail' do
        expect { subject }.to raise_error(/There are only default configs for Apache and Nginx./)
      end
    end

    context 'icinga_webserver_port not an integer' do
      let :faulty_params do {
        :icinga_webserver_port => 'lighttpd',
      }
      end
      let :params do {}.merge(default_params).merge(faulty_params)
      end
      it 'should fail' do
        expect { subject }.to raise_error(/icinga_webserver_port must be an integer./)
      end
    end

    it 'should chain child classes in the right order' do
      should contain_class('icinga::server::users').with({:before => 'Class[Icinga::Server::Packages]',})
      should contain_class('icinga::server::packages').with({:before => 'Class[Icinga::Server::Configs]',})
      should contain_class('icinga::server::configs').with({:before => 'Class[Icinga::Server::Services]'})
      should contain_class('icinga::server::services').with({:before => 'Class[Icinga::Server]'})
    end

  end # end normal operation

  describe 'on unsupported' do
    let :facts do
      { :osfamily => 'Little Red Riding Hood' }
    end
    it 'should fail' do
      expect { subject }.to raise_error(/osfamily Little Red Riding Hood is not supported/)
    end
  end

end
