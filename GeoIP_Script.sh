#https://medium.com/@maxime.durand.54/add-the-geoip2-module-to-nginx-f0b56e015763

#"sudo" enables users to run programs with the security privileges of another user
#"apt" is a high-level computer programming language that is used to generate instructions.

#A script which adds an external APT repository or removes an already existing repository - "add-apt-repository [OPTIONS] REPOSITORY"
#Ubuntu
#ppa:maxmind/ppa is the repository
$ sudo add-apt-repository ppa:maxmind/ppa


#After adding the repository, update the package cache with packages from this repository
$ sudo apt update


#"libmaxminddb" library provides a C library for reading MaxMind DB files, including the GeoIP2 databases from MaxMind.
#"mmdb-bin" This package contains the command line utilities to resolve IPs using the libmaxminddb library.
#"libmaxminddb-dev" This package contains the development files for the libmaxminddb library.


#Install the geoipupdate packages from your package manager
sudo apt install geoipupdate libmaxminddb0 libmaxminddb-dev mmdb-bin

#Create a MaxMind Account
#https://www.maxmind.com/en/accounts/current/license-key
#Then go to manage licenses key and click on generate license key
#In the /etc/GeoIP.conf file, replace "YOUR_ACCOUNT_ID_HERE" & "YOUR_LICENSE_KEY_HERE" with your accound id number and license key from your Maxmind account
#Depending on the license you might need to change the EditionIDs

#update the geoip database
$ sudo geoipupdate

#"cron" submits, edits, lists, or removes cron jobs. A cron job is a command run by the cron daemon at regularly scheduled intervals. 
#To submit a cron job, specify the crontab command with the -e flag. 

#add a new cron rulle to enable a daily update
$ sudo crontab -e

# Run GeoIP database update every thursday at 02:00
$ 0 2 * * 2 /usr/bin/geoipupdate

#Add the GeoIP2 module to Nginx. This clones the github repository of the module
$ git clone https://github.com/leev/ngx_http_geoip2_module.git

#Check your Nginx version before downloading with this command below
# $ nginx-v

# "tar" means an archiving utility, "z" means unzip, "x" means extract files from archive, "v" means print the filenames verbosely, "f" means the following argument is a filename
# "wget" means the non-interative network downloader
# "cd" allows you to change directories

#Download the Nginx corresponding version
$ wget http://nginx.org/download/nginx-VERSION.tar.gz
$ tar zxvf nginx-VERSION.tar.gz
$ cd nginx-VERSION

#Make the module
$ ./configure --with-compat --add-dynamic-module=../ngx_http_geoip2_module
$ make modules

#"mkdir" makes a new directory
#"-p" means parents, so when you put it with mkdir it makes a parent directory

#Copy the GeoIP2 module in the Nginx directory
$ mkdir -p /etc/nginx/modules

$ cp -vi objs/ngx_http_geoip2_module.so /etc/nginx/modules/

#Add the module to the nginx.conf
$ load_module modules/ngx_http_geoip2_module.so;

#Check the Nginx configuration
#$ sudo nginx -t
#$ nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
#$ nginx: configuration file /etc/nginx/nginx.conf test is successful

#Restrict any servers from certain countries, by editing /etc/nginx/nginx.conf
[...]

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

       [...]
    }
}
