#A script which adds an external APT repository or removes an already existing repository
#Ubuntu
#ppa:maxmind/ppa is the repository
$ sudo add-apt-repository ppa:maxmind/ppa

#After adding the repository, update the package cache with packages from this repository
$ sudo apt update

#Install the geoipupdate packages from your package manager
sudo apt install geoipupdate libmaxminddb0 libmaxminddb-dev mmdb-bin

#Create a MaxMind Account and generate a new license key
#https://www.maxmind.com/en/accounts/current/license-key
#In the /etc/GeoIP.conf file, replace "YOUR_ACCOUNT_ID_HERE" & "YOUR_LICENSE_KEY_HERE" with your accound id number and license key
#Depending on the license you might need to change the EditionIDs

#update the geoip database
$ sudo geoipupdate

#add a new cron rulle to enable a daily update
$ sudo crontab -e

# Run GeoIP database update every thursday at 02:00
0 2 * * 2 /usr/bin/geoipupdate

#Add the GeoIP2 module to Nginx. This clones the github repository of the module
$ git clone https://github.com/leev/ngx_http_geoip2_module.git

#Check your Nginx version before downloading 
# $ nginx-v

#Download the Nginx corresponding version
$ wget http://nginx.org/download/nginx-VERSION.tar.gz
$ tar zxvf nginx-VERSION.tar.gz
$ cd nginx-VERSION

#Make the module
$ ./configure --with-compat --add-dynamic-module=../ngx_http_geoip2_module

$ make modules

#Copy the GeoIP2 module in the Nginx directory
$ mkdir -p /etc/nginx/modules

$ cp -vi objs/ngx_http_geoip2_module.so /etc/nginx/modules/

#Add the module to the nginx.conf
$ load_module modules/ngx_http_geoip2_module.so;