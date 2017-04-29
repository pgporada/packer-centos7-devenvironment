require 'spec_helper'

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe file('/usr/sbin/httpd'), :if => os[:family] == 'redhat' do
  it { should be_executable }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe command('httpd -M') do
  its(:stdout) { should contain('php5_module') }
end

describe command('httpd -V') do
  # test 'event' exists between "Server MPM" and "Server compiled".
  its(:stdout) { should contain('prefork').from(/^Server MPM/).to(/^Server compiled/) }

  # test 'conf/httpd.conf' exists after "SERVER_CONFIG_FILE".
  its(:stdout) { should contain('conf/httpd.conf').after('SERVER_CONFIG_FILE') }

  # test 'Apache/2.4.x' exists before "Server built".
  its(:stdout) { should contain(' Apache/2.4.').before('Server built') }
end

%w{80}.each do |ports|
  describe port(ports) do
    it { should be_listening }
  end
end

describe file('/var/log/httpd') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 700 }
end


%w{/etc/httpd/vhosts.d /etc/httpd/vhosts.d/includes}.each do |folder|
  describe file(folder) do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end
end
