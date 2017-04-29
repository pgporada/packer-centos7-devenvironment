require 'spec_helper'

%w{openssh-clients openssh-server}.each do |pkg|
  describe package(pkg), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end
end

describe service('sshd') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/ssh/sshd_config') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 600 }
end

describe port(22) do
  it { should be_listening }
end


describe 'check ssh_config' do
  describe file('/etc/ssh/ssh_config') do
    its(:content) { should match(/^Host/) }
    its(:content) { should match(/^    Port [0-9]?/) }
    its(:content) { should match(/^    Protocol 2$/) }
    its(:content) { should match(/^    ForwardAgent no$/) }
    its(:content) { should match(/^    ForwardX11 no$/) }
    its(:content) { should match(/^    HostbasedAuthentication no$/) }
    its(:content) { should match(/^    RhostsRSAAuthentication no$/) }
    its(:content) { should match(/^    GSSAPIAuthentication no$/) }
    its(:content) { should match(/^    GSSAPIDelegateCredentials no$/) }
    its(:content) { should match(/^    Compression yes$/) }
    its(:content) { should match(/^    ForwardX11Trusted yes$/) }
  end
end
