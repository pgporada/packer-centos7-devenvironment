require 'spec_helper'

%w{php php-common php-fpm php-mysqlnd php-mcrypt php-mbstring php-cli php-soap php-pear php-devel}.each do |pkg|
  describe package(pkg), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end
end

describe file('/usr/bin/php') do
  it { should be_executable }
end

describe 'PHP config parameters' do
  context  php_config('default_mimetype') do
    its(:value) { should eq 'text/html' }
  end

  context php_config('session.cache_expire') do
    its(:value) { should eq 180 }
  end
end

%w{/var/lib/php/wsdlcache /var/lib/php/session}.each do |folder|
  describe file(folder) do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
    it { should be_mode 770 }
  end
end
