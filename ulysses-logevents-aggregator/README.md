Ulysses - log aggregator
--------------------------

```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.0.tar.gz

nohup elasticsearch-5.3.0/bin/elasticsearch &

```

indexstorage.service

```bash
[Unit]
Description=indexing-store

[Service]
Type=forking
ExecStart=/usr/local/elasticsearch-5.2.2/bin/elasticsearch
TimeoutSec=infinity
Restart=always

[Install]
WantedBy=multi-user.target
```

Ulysses UI
--------------

```bash
wget https://artifacts.elastic.co/downloads/kibana/kibana-5.3.0-linux-x86_64.tar.gz


```


[Alerting](https://elastalert.readthedocs.io/en/latest/)
---------

```bash

git clone https://github.com/Yelp/elastalert.git

# remove python3 if exists
# which was the case for ubuntu
# Linux ip-172-24-41-161 4.4.0-64-generic #85-Ubuntu SMP Mon Feb 20 11:50:30 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

# yum uninstall python3
# apt-get remove python3
# python --version
# Python 2.7.12

#on debian OS
apt-get -y install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev

apt-get -y install python-setuptools

#install
#setup proxy if needed
sudo python setup.py install
# or 
# sudo chmod -R 777 /usr/local/lib/python2.7/
# sudo chmod -R 777 /usr/local/lib/python2.7/

#install pip
# apt-get install python-pip python-dev build-essential 
pip --version
pip 8.1.1 from /usr/lib/python2.7/dist-packages (python 2.7)

#fix crypto issue
apt-get install build-essential libssl-dev libffi-dev python-dev
pip install cryptography
pip install -r requirements.txt
```

alerting config
------------

- setup config with Elasticseach scheme, host and port.
- set rules folder

create index
---------------

```bash
root@ip-172-24-41-161:/usr/local/elastalert# elastalert-create-index
Enter Elasticsearch host: 172.24.41.161
Enter Elasticsearch port: 9200
Use SSL? t/f: f
Enter optional basic-auth username (or leave blank): 
Enter optional basic-auth password (or leave blank): 
Enter optional Elasticsearch URL prefix (prepends a string to the URL of every request): 
New index name? (Default elastalert_status) alerting_metadata
Name of existing index to copy? (Default None) 
New index alerting_metadata created
Done!
```

[Alert Rules in `/etc/alert-service/errors.yaml`](https://elastalert.readthedocs.io/en/latest/recipes/writing_filters.html#writingfilters)
------

```yaml
es_host: search-duwamish-api-id.us-east-1.es.amazonaws.com 
es_port: 443
name: Error alert rule
type: frequency
index: myapplication-*
num_events: 1
timeframe:
    minutes: 5
filter:
- query:
   query_string:
      query: "\"ERROR\""
alert:
- "email"
email:
- "prayag.y@gmail.com"
```

Run alert process
-------------------

linux service
---

```bash
[Unit]
Description=Alerting service

[Service]
Type=forking
ExecStart=/usr/bin/python -m elastalert.elastalert --verbose --config /usr/local/elastalert/streaming-alerts.yaml
ExecStop=/bin/sh -c "echo 'Index stopped'"
TimeoutSec=infinity
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
elastalert --verbose  --config /etc/alert-service/alerting_config.yaml > alerting.out 2>&1 &
python -m elastalert.elastalert --verbose --config /usr/local/elastalert/streaming-alerts.yaml > alerting.out 2>&1 &
```

