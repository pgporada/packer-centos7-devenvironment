require 'spec_helper'

%w{mysql-community-release mysql-community-client mysql-community-libs mysql-community-server mysql-community-common}.each do |pkg|
  describe package(pkg), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end
end

describe file('/usr/bin/mysql'), :if => os[:family] == 'redhat' do
  it { should be_executable }
end

describe service('mysqld'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/lib/mysql/mysql.sock'), :if => os[:family] == 'redhat' do
  it { should be_socket }
end

describe file('/var/log/mysql'), :if => os[:family] == 'redhat' do
  it { should be_directory }
end


describe 'Parsing configfiles for unwanted entries' do
  describe file('/etc/my.cnf') do
    its(:content) { should match_key_value('datadir', '/var/lib/mysql') }
    its(:content) { should_not match_key_value('old_passwords', '1') }
    its(:content) { should match_key_value('symbolic-links', '0') }
	its(:content) { should match_key_value('character-set-server', 'utf8mb4') }
	its(:content) { should match_key_value('default-character-set', 'utf8mb4') }
	its(:content) { should match_key_value('collation-server', 'utf8mb4_bin') }
  end
end

describe 'Check for multiple instances' do
  describe command('ps aux | grep mysqld | egrep -v "grep|mysqld_safe|logger" | wc -l') do
    its(:stdout) { should match(/^1$/) }
  end
end

describe 'Mysql environment' do
  describe command('env') do
    its(:stdout) { should_not match(/^MYSQL_PWD=/) }
  end
end
