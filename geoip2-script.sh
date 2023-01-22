#https://medium.com/@maxime.durand.54/add-the-geoip2-module-to-nginx-f0b56e015763
#https://www.linuxfordevices.com/tutorials/linux/automatic-updates-cronjob
#https://www.codedodle.com/nginx-geoip2-ubuntu.html

#"sudo" enables users to run programs with the security privileges of another user
#"apt" is a high-level computer programming language that is used to generate instructions.

#A script which adds an external APT repository or removes an already existing repository - "add-apt-repository [OPTIONS] REPOSITORY"
#Ubuntu
#ppa:maxmind/ppa is the repository
 sudo add-apt-repository ppa:maxmind/ppa


#After adding the repository, update the package cache with packages from this repository
 sudo apt update


#"libmaxminddb" library provides a C library for reading MaxMind DB files, including the GeoIP2 databases from MaxMind.
#"mmdb-bin" This package contains the command line utilities to resolve IPs using the libmaxminddb library.
#"libmaxminddb-dev" This package contains the development files for the libmaxminddb library.


#Install the geoipupdate packages from your package manager
sudo apt install geoipupdate libmaxminddb0 libmaxminddb-dev mmdb-bin

#Create a MaxMind Account
#https://www.maxmind.com/en/accounts/current/license-key
#Then go to manage licenses key and click on generate license key
#In the /etc/GeoIP.conf file, replace "YOUR_ACCOUNT_ID_HERE" & "YOUR_LICENSE_KEY_HERE" with your account id number and license key
#Depending on the license you might need to change the EditionIDs

#update the geoip database
 sudo geoipupdate

#"cron" submits, edits, lists, or removes cron jobs. A cron job is a command run by the cron daemon at regularly scheduled intervals. 
#To submit a cron job, specify the crontab command with the -e flag. 
#The cron format - [minute] [hour] [day_of_month] [month] [day_of_week] [user] [command_to_run]

#Install Cron utilities
sudo apt install cron

#Enable the cron service to run in the background, systemctl is a abbreviation for system controls. Used to manage services on the system.
sudo systemctl enable cron
 
#Update the system to the global crontab
 sudo nano /etc/crontab

#Update the Ubuntu system every thursday at 02:00
0 2 * * THU root /usr/bin/apt update -q -y >> /var/log/apt/automaticupdates.log

# Run a quick IP lookup, to check if it is working correctly. If it is showing country names then it should be good
#sudo mmdblookup --file /usr/share/GeoIP/GeoLite2-Country.mmdb --ip 8.8.8.8

#Make a Directory for the source code
cd ~
mkdir nginx-compile
cd nginx-compile

#Add the GeoIP2 module to Nginx. This clones the github repository of the module
 git clone https://github.com/leev/ngx_http_geoip2_module.git

#Check your Nginx version before downloading with this command below
#  nginx-v 

# Example Output: nginx version: nginx/1.18.0 (Ubuntu)
# If your nginx version is that then type in this:
# wget http://nginx.org/download/nginx-1.18.0.tar.gz
# tar zxvf nginx-1.18.0.tar.gz
# If not then ignore

# "tar" means an archiving utility, "z" means unzip, "x" means extract files from archive, "v" means print the filenames verbosely, "f" means the following argument is a filename
# "wget" means the non-interative network downloader
# "cd" allows you to change directories

# If you typed in nginx-v then replace "VERSION" with the version number it tells you. Do not actually type "VERSION"
#Download the Nginx corresponding version

wget http://nginx.org/download/nginx-VERSION.tar.gz
tar zxvf nginx-VERSION.tar.gz

cd nginx-VERSION

#Example Output:
#nginx version: nginx/1.18.0 (Ubuntu)
#built with OpenSSL 1.1.1f 31 Mar 2020
#TLS SNI support enabled
#configure arguments: --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-KTLRnK/nginx-1.18.0=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-compat --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-mail=dynamic --with-mail_ssl_module

#Copy all the text after "configure arguments:"

#Make the module
 ./configure --PASTE-THE-CODE-HERE --add-dynamic-module=../ngx_http_geoip2_module
 #Example: "./configure --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-KTLRnK/nginx-1.18.0=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-compat --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-mail=dynamic --with-mail_ssl_module --add-dynamic-module=../ngx_http_geoip2_module"

#If you do not have make installed, then install it with this
sudo apt install make
make install
#to get rid of the errors
sudo apt install gcc libssl-dev libpcre3 libpcre3-dev zlib1g-dev libxslt-dev libgd-dev libssl-dev make

#Then compile the source code with make
make 

#Create a new conf file in /usr/share/nginx/modules-available
cd /usr/share/nginx/modules-available
touch mod-http-geoip2.conf

#Add the module to the nginx.conf
 load_module modules/ngx_http_geoip2_module.so;
 
#Enable the module by creating a symbolic link in /etc/nginx/modules-enabled/
 sudo ln -s /usr/share/nginx/modules-available/mod-http-geoip2.conf /etc/nginx/modules-enabled/

#Check the Nginx configuration
 sudo nginx -t
#Example Output: 
#nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
#nginx: configuration file /etc/nginx/nginx.conf test is successful

#Restrict any servers from certain countries, by editing /etc/nginx/nginx.conf

http {
    geoip2 /var/lib/GeoIP/GeoLite2-Country.mmdb {
       $geoip2_data_country_iso_code country iso_code;
    }

    map $geoip2_data_country_iso_code $allowed_country {
       default no;
       FR yes; # France
       BE yes; # Belgium
       DE yes; # Germany
       CH yes; # Switzerland
    }

    server {
       # Block forbidden country
       if ($allowed_country = no) {
           return 444;
       }
       #or use this instead
       #location ~ /wp-login.php {
       #if ($allowed_country = no) {
        #return 503;
        #}
        #}
    }
}

#Test and reload the code
sudo nginx -t
sudo systemctl reload nginx
