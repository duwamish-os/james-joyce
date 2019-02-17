# on mac
#wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.0-linux-x86_64.tar.gz
mkdir /usr/local/log-forwarder
chmod -R 777 /usr/local/log-forwarder
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.0-linux-x86_64.tar.gz -P /usr/local/log-forwarder
tar -xf /usr/local/log-forwarder/filebeat-6.6.0-linux-x86_64.tar.gz -C /usr/local/log-forwarder --strip-components=1
chmod go-w /usr/local/log-forwarder/filebeat.yml

