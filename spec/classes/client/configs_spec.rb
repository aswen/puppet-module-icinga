require 'spec_helper'

describe 'icinga::client::configs' do

  d_nagios     = '/etc/nagios'
  d_nagios_lib = '/usr/lib/nagios'
  let :default_params do {
    :icinga_servers      => ['1.2.3.4','2.3.4.5'],
    :d_nrpe              => "#{d_nagios}/nrpe.d",
    :f_nrpe_config       => "#{d_nagios}/nrpe.cfg",
    :f_local_nrpe_config => "#{d_nagios}/nrpe_local.cfg",
  }
  end

  let :params do {}.merge(default_params)
  end #merge

  it 'should declare itself' do
    should contain_class('icinga::client::configs')
  end

  context 'all possible params sent to nrpe.cfg.erb' do
    let :params_sent do {
      :log_facility           => 'David Jason',
      :pid_file               => '/dev/null',
      :server_port            => 22,
      :server_address         => '1.0.0.1',
      :nrpe_user              => 'Jack Frost',
      :nrpe_group             => 'Denton CID',
      :dont_blame_nrpe        => 1,
      :command_prefix         => 'chop chop',
      :debug                  => 1,
      :command_timeout        => 2009,
      :connection_timeout     => 2010,
      :allow_weak_random_seed => 0,
      :f_local_nrpe_config    => 'Mullet',
      :include_dir            => 'R.D.Wingfield',
    }
    end # params_sent
    let :params do {}.merge(default_params).merge(params_sent)
    end # merge params
    it 'file_nrpe_config should manage the nrpe.cfg file' do
      should contain_file(params[:f_nrpe_config]).with({
        :mode    => '0644',
        :owner   => 'root',
        :group   => 'root',
        :notify  => "Class[Icinga::Client::Services]",}).
      with_content(/^log_facility=David Jason$/).
      with_content(/^pid_file=\/dev\/null$/).
      with_content(/^server_port=22$/).
      with_content(/^server_address=1.0.0.1$/).
      with_content(/^nrpe_user=Jack Frost$/).
      with_content(/^nrpe_group=Denton CID$/).
      with_content(/^allowed_hosts=127.0.0.1,#{default_params[:icinga_servers].join(',')}$/).
      with_content(/^dont_blame_nrpe=1$/).
      with_content(/^command_prefix=chop chop$/).
      with_content(/^debug=1$/).
      with_content(/^command_timeout=2009$/).
      with_content(/^connection_timeout=2010$/).
      with_content(/^allow_weak_random_seed=0$/).
      with_content(/^include=Mullet$/).
      with_content(/^include_dir=R.D.Wingfield\/$/)
    end # file_nrpe_config should manage the nrpe.cfg.erb
  end # context all params sent to nrpe.cfg


  it 'file_local_nrpe_config should manage the nrpe_local.cfg file' do
    should contain_file(default_params[:f_local_nrpe_config]).with({
      :ensure  => 'present',
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
    })
  end

  it 'dir_nrpe should manage the entire configdir' do
    should contain_file(default_params[:d_nrpe]).with({
      :ensure  => 'directory',
      :mode    => '0755',
      :owner   => 'root',
      :group   => 'root',
      :recurse => 'true',
      :purge   => 'true',
      :notify  => "Class[Icinga::Client::Services]",
    })
  end

end #describe icinga::client::configs
