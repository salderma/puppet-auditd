require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'auditd' do

  let(:title) { 'auditd' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('audit').with_ensure('present') }
    it { should contain_service('auditd').with_ensure('running') }
    it { should contain_service('auditd').with_enable('true') }
    it { should contain_file('auditd.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('audit').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring' do
    let(:params) { {:monitor => true } }
    it { should contain_package('audit').with_ensure('present') }
    it { should contain_service('auditd').with_ensure('running') }
    it { should contain_service('auditd').with_enable('true') }
    it { should contain_file('auditd.conf').with_ensure('present') }
    it { should contain_monitor__process('auditd_process').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true } }
    it 'should remove Package[audit]' do should contain_package('audit').with_ensure('absent') end
    it 'should stop Service[auditd]' do should contain_service('auditd').with_ensure('stopped') end
    it 'should not enable at boot Service[auditd]' do should contain_service('auditd').with_enable('false') end
    it 'should remove auditd configuration file' do should contain_file('auditd.conf').with_ensure('absent') end
    it { should contain_monitor__process('auditd_process').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true } }
    it { should contain_package('audit').with_ensure('present') }
    it 'should stop Service[auditd]' do should contain_service('auditd').with_ensure('stopped') end
    it 'should not enable at boot Service[auditd]' do should contain_service('auditd').with_enable('false') end
    it { should contain_file('auditd.conf').with_ensure('present') }
    it { should contain_monitor__process('auditd_process').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true } }
    it { should contain_package('audit').with_ensure('present') }
    it { should_not contain_service('auditd').with_ensure('present') }
    it { should_not contain_service('auditd').with_ensure('absent') }
    it 'should not enable at boot Service[auditd]' do should contain_service('auditd').with_enable('false') end
    it { should contain_file('auditd.conf').with_ensure('present') }
    it { should contain_monitor__process('auditd_process').with_enable('false') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true, :monitor => true } }
    it { should contain_package('audit').with_noop('true') }
    it { should contain_service('auditd').with_noop('true') }
    it { should contain_file('auditd.conf').with_noop('true') }
    it { should contain_monitor__process('auditd_process').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "auditd/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', 'auditd.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'auditd.conf').send(:parameters)[:content]
      content.should match "value_a"
    end

  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/auditd/spec"} }
    it { should contain_file('auditd.conf').with_source('puppet:///modules/auditd/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/auditd/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('auditd.dir').with_source('puppet:///modules/auditd/dir/spec') }
    it { should contain_file('auditd.dir').with_purge('true') }
    it { should contain_file('auditd.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "auditd::spec" } }
    it { should contain_file('auditd.conf').with_content(/rspec.example42.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'auditd.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('auditd').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('auditd_process').with_tool('puppi') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('auditd_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :auditd_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour module specific vars' do should contain_monitor__process('auditd_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :auditd_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('auditd_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }
    it 'should honour passed params over global vars' do should contain_monitor__process('auditd_process').with_enable('true') end
  end

end

