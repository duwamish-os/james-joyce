[filebeat](https://www.elastic.co/downloads/beats/filebeat)
------------------

https://www.elastic.co/guide/en/beats/filebeat/current/elasticsearch-output.html#elasticsearch-output

```bash

# on mac

#wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.0-darwin-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.0-linux-x86_64.tar.gz
chmod go-w /usr/local/filebeat-5.3.0-linux-x86_64/filebeat.yml
```

```bash
[Unit]
Description=Log forwarder pipeline

[Service]
Type=forking
ExecStart=/usr/local/filebeat-5.3.0-linux-x86_64/filebeat -c /usr/local/filebeat-5.3.0-linux-x86_64/log-forwarder.yml
ExecStop=/bin/sh -c "echo 'Alerting stopped'"
TimeoutSec=infinity
Restart=always

[Install]
WantedBy=multi-user.target
```

```yaml

- input_type: log

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /var/log/stream-pipeline.log
    #- c:\programdata\elasticsearch\logs\*

#fields:
#  env: staging

#================================ Outputs =====================================

# Configure what outputs to use when sending the data collected by the beat.
# Multiple outputs may be used.

#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["localhost:9200"]
  index: "myapplication-%{environment}-%{+YYYY.MM.dd}"

  # Optional protocol and basic auth credentials.
  #protocol: "https"
  #username: "elastic"
  #password: "changeme"

#================================ Logging =====================================

# Sets log level. The default log level is info.
# Available log levels are: critical, error, warning, info, debug
#logging.level: debug

# At debug level, you can selectively enable logging only for some components.
# To enable all selectors use ["*"]. Examples of other selectors are "beat",
# "publish", "service".
#logging.selectors: ["*"]

```

[Then](https://gist.github.com/prayagupd/7339599)
------

```
curl -XGET http://localhost:9200/_aliases

curl -XGET http://localhost:9200/filebeat-2017.04.12/log/_search

```
