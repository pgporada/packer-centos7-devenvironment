#!/bin/bash
# AUTHOR: Phil Porada - philporada@gmail.com
# WHAT: Bootstraps the vagrant with a base set of tools

echo "gem: --no-ri --no-rdoc" > /root/.gemrc
chown root:root /root/.gemrc
echo "gem: --no-ri --no-rdoc" > /home/vagrant/.gemrc
chown vagrant:vagrant /home/vagrant/.gemrc

# EPEL, Remi, and Chrome Repositories
VER=$(rpm -q --queryformat '%{VERSION}' centos-release)
rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${VER}
yum install -y epel-release

rpm -q remi-release &>/dev/null
if [ $? -eq 1 ]; then
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-${VER}.rpm &>/dev/null
fi
sed -i '/\[remi\]/,/^ *\[/ s/enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo
sed -i '/\[remi-php56\]/,/^ *\[/ s/enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo

cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

# System updates and extra packages
yum install -y deltarpm
yum update -y
yum install -y gcc make gcc-c++ kernel-devel-$(uname -r) zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils bzip2 vim rsync curl telnet screen zsh vim nano git emacs-nox remi-release httpd net-tools yum-versionlock sendmail java-1.8.0-openjdk-headless innotop unzip python-devel python-pip openssl-devel libffi-devel yum-utils python-boto
yum install -y php php-common php-fpm php-opcache php-apcu php-mysql php-mcrypt php-mbstring php-cli php-soap php-pdo php-gd php-pear php-devel ansible awscli
yum install -y ruby rubygems-rdoc ruby-devel rubygems
yum update -y
gem install --no-user-install bundler
pip install --upgrade pip
pip install --upgrade setuptools

# MySQL 5.5
rpm -Uvh https://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
sed -i '/\[mysql55-community\]/,/^ *\[/ s/enabled=0/enabled=1/' /etc/yum.repos.d/mysql-community.repo
sed -i '/\[mysql56-community\]/,/^ *\[/ s/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
yum install -y mysql-community-server mysql-community-libs

# Headless Selenium via Xvfb
yum install -y xorg-x11-server-Xvfb google-chrome-stable php-phpunit-PHPUnit-Selenium firefox
gem install selenium-webdriver headless
CHROMEVER=$(curl -s http://chromedriver.storage.googleapis.com/LATEST_RELEASE)
curl -s "http://chromedriver.storage.googleapis.com/$CHROMEVER/chromedriver_linux64.zip" > /tmp/chromedriver.zip
unzip /tmp/chromedriver.zip && sudo mv /tmp/chromedriver /usr/local/bin/
rm -f /tmp/chromedriver.zip
pecl install -Z xdebug
pecl install xhprof-beta

# Since it's a dev box, remove the firewall
iptables -F
systemctl stop firewalld
systemctl mask firewalld

# NodeJS and NPM
yum install -y libicu
yum install -y https://rpm.nodesource.com/pub_6.x/el/7/x86_64/nodejs-6.9.1-1nodesource.el7.centos.x86_64.rpm

# Install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# Install grunt globally
npm install -g grunt-cli grunt

# Configuring httpd
mkdir -p /etc/httpd/vhosts.d/includes
# Thanks Matt!
# Fixes session issues
mkdir -p /var/lib/php/{session,wsdlcache}
chown vagrant:vagrant /var/lib/php/session
chown vagrant:vagrant /var/lib/php/wsdlcache

# Configuring mysql
chsh -s /bin/bash mysql
mkdir -p /var/log/mysql
chown mysql:mysql /var/lib/mysql/.bashrc
chown mysql:mysql /var/lib/mysql/.bash_profile
chown mysql:mysql /var/log/mysql
cat << EOL > /etc/my.cnf
# https://dev.mysql.com/doc/refman/5.5/en/charset-unicode-utf8mb4.html
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
character-set-server=utf8mb4
collation-server=utf8mb4_bin
innodb_file_per_table
innodb_buffer_pool_size=256m
innodb_flush_method=O_DIRECT
max_allowed_packet=20M
general_log=1
slow_query_log=1
slow_query_log_file=/var/log/mysql/mysql-log-slow-queries.log
long_query_time=10
log-error=/var/log/mysql/mysqld.log
optimizer_prune_level=1
optimizer_search_depth=0
optimizer_switch=index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on
group_concat_max_len=1048576

[mysqld_safe]
log-error=/var/log/mysql/mysqld.log
pid-file=/var/run/mysqld/mysql.pid

[client]
default-character-set=utf8mb4
EOL

# Start services
systemctl enable httpd
systemctl start httpd
systemctl enable mysqld
systemctl start mysqld
systemctl disable php-fpm

if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm -f /etc/udev/rules.d/70-persistent-net.rules
fi
