#!/bin/bash

file=$1
user=$2
pass=$3
includeView=$4

sudo apt-get install -y apache2 

export DEBIAN_FRONTEND="noninteractive"
echo 'mysql-server mysql-server/root_password password '$pass ' 
mysql-server mysql-server/root_password_again password '$pass > /root/src/debconf.txt
debconf-set-selections /root/src/debconf.txt

sudo apt-get install -y mariadb-server 

sudo apt-get install -y libapache2-mod-php5
sudo apt-get install -y php5-gd php5-json php5-mysql php5-curl
sudo apt-get install -y php5-intl php5-mcrypt php5-imagick



if   [ ! -d /var/www/nextcloud/ ];then
		sudo chmod 777 /var
		sudo chmod 777 /var/www
		unzip $file -d /var/www
	
fi

sudo chmod 777 /etc/apache2/sites-available
 

echo "Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/nextcloud
 SetEnv HTTP_HOME /var/www/nextcloud

</Directory>" > /etc/apache2/sites-available/nextcloud.conf

sudo chmod 777 /etc/apache2/sites-enabled

ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf


sudo chown -R www-data:www-data /var/www/nextcloud/

cd /var/www/nextcloud/

mysql -u $user -p$pass -e "CREATE DATABASE IF NOT EXISTS nextcloud" 

sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user $user --database-pass $pass --admin-user "nextcloud" --admin-pass "nextcloud"

sudo /etc/init.d/apache2 stop
sudo /etc/init.d/apache2 start

