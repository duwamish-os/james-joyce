Ulysses - log aggregator
--------------------------

```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.0.tar.gz

nohup elasticsearch-5.1.1/bin/elasticsearch &

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
--

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
sudo python setup.py install
# or 
# sudo chmod -R 777 /usr/local/lib/python2.7/
# sudo chmod -R 777 /usr/local/lib/python2.7/

#install pip
# apt-get install python-pip python-dev build-essential 
pip --version
pip 8.1.1 from /usr/lib/python2.7/dist-packages (python 2.7)

#fix crypto issue
# apt-get install build-essential libssl-dev libffi-dev python-dev
# pip install cryptography
pip install -r requirements.txt
```

alerting config
------------

```bash
# This is the folder that contains the rule yaml files
# Any .yaml file will be loaded as a rule
rules_folder: /etc/alert_rules/

# ElastAlert will buffer results from the most recent
# period of time, in case some log sources are not in real time
buffer_time:
  minutes: 1

# The Elasticsearch hostname for metadata writeback
# Note that every rule can have its own Elasticsearch host
es_host: 172.21.3.9

# The Elasticsearch port
es_port: 9200

# The AWS region to use. Set this when using AWS-managed elasticsearch
#aws_region: us-west-1

# The AWS profile to use. Use this if you are using an aws-cli profile.
# See http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
# for details
#profile: test

# Optional URL prefix for Elasticsearch
#es_url_prefix: elasticsearch

# Connect with TLS to Elasticsearch
#use_ssl: True

# Verify TLS certificates
#verify_certs: True

# GET request with body is the default option for Elasticsearch.
# If it fails for some reason, you can pass 'GET', 'POST' or 'source'.
# See http://elasticsearch-py.readthedocs.io/en/master/connection.html?highlight=send_get_body_as#transport
# for details
#es_send_get_body_as: GET

# Option basic-auth username and password for Elasticsearch
#es_username: someusername
#es_password: somepassword

# The index on es_host which is used for metadata storage
# This can be a unmapped index, but it is recommended that you run
# elastalert-create-index to set a mapping
# writeback_index: elastalert_status
writeback_index: alerting_metadata

# If an alert fails for some reason, ElastAlert will retry
# sending the alert until this time period has elapsed
alert_time_limit:
  days: 1

```

[Alert Rules in `/etc/alert-service/errors.yaml`](https://elastalert.readthedocs.io/en/latest/recipes/writing_filters.html#writingfilters)
------

```yaml
#es_host: localhost
#es_port: 9200
name: Error alert rule
type: frequency
index: filebeat-*
num_events: 1
#timeframe:
#    hours: 4
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

service
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
python -m elastalert.elastalert --verbose --config /usr/local/elastalert/streaming-alerts.yaml
Traceback (most recent call last):
  File "/usr/lib/python2.7/runpy.py", line 174, in _run_module_as_main
    "__main__", fname, loader, pkg_name)
  File "/usr/lib/python2.7/runpy.py", line 72, in _run_code
    exec code in run_globals
  File "/usr/local/lib/python2.7/dist-packages/elastalert-0.1.8-py2.7.egg/elastalert/elastalert.py", line 1591, in <module>
    sys.exit(main(sys.argv[1:]))
  File "/usr/local/lib/python2.7/dist-packages/elastalert-0.1.8-py2.7.egg/elastalert/elastalert.py", line 1586, in main
    client = ElastAlerter(args)
  File "/usr/local/lib/python2.7/dist-packages/elastalert-0.1.8-py2.7.egg/elastalert/elastalert.py", line 95, in __init__
    self.conf = load_rules(self.args)
  File "/usr/local/lib/python2.7/dist-packages/elastalert-0.1.8-py2.7.egg/elastalert/config.py", line 425, in load_rules
    raise EAException('Error loading file %s: %s' % (rule_file, e))
elastalert.util.EAException: Error loading file /etc/alert_rules/errors.yaml: Invalid Rule file: /etc/alert_rules/errors.yaml
{'filter': [{'query': {'query_string': {'query': '"ERROR"'}}}], 'index': 'filebeat-*', 'name': 'Error alert rule', 'rule_file': '/etc/alert_rules/errors.yaml', 'type': 'frequency', 'email': ['prayag.upadhyay@nordstrom.com'], 'num_events': 1, 'alert': ['email']} is not valid under any of the given schemas

Failed validating 'oneOf' in schema:
    {'$schema': 'http://json-schema.org/draft-04/schema#',
     'definitions': {'arrayOfStrings': {'items': {'type': 'string'},
                                        'type': ['string', 'array']},
                     'arrayOfStringsOrOtherArrays': {'items': {'type': ['string',
                                                                        'array']},
                                                     'type': ['string',
                                                              'array']},
                     'filter': {},
                     'timeFrame': {'additionalProperties': False,
                                   'properties': {'days': {'type': 'number'},
                                                  'hours': {'type': 'number'},
                                                  'milliseconds': {'type': 'number'},
                                                  'minutes': {'type': 'number'},
                                                  'schedule': {'type': 'string'},
                                                  'seconds': {'type': 'number'},
                                                  'weeks': {'type': 'number'}},
                                   'type': 'object'}},
     'oneOf': [{'properties': {'type': {'enum': ['any']}},
                'title': 'Any'},
               {'properties': {'blacklist': {'items': {'type': 'string'},
                                             'type': 'array'},
                               'compare_key': {'type': 'string'},
                               'type': {'enum': ['blacklist']}},
                'required': ['blacklist', 'compare_key'],
                'title': 'Blacklist'},
               {'properties': {'compare_key': {'type': 'string'},
                               'ignore_null': {'type': 'boolean'},
                               'type': {'enum': ['whitelist']},
                               'whitelist': {'items': {'type': 'string'},
                                             'type': 'array'}},
                'required': ['whitelist', 'compare_key', 'ignore_null'],
                'title': 'Whitelist'},
               {'properties': {'compare_key': {'type': 'string'},
                               'ignore_null': {'type': 'boolean'},
                               'timeframe': {'additionalProperties': False,
                                             'properties': {'days': {'type': 'number'},
                                                            'hours': {'type': 'number'},
                                                            'milliseconds': {'type': 'number'},
                                                            'minutes': {'type': 'number'},
                                                            'schedule': {'type': 'string'},
                                                            'seconds': {'type': 'number'},
                                                            'weeks': {'type': 'number'}},
                                             'type': 'object'},
                               'type': {'enum': ['change']}},
                'required': ['query_key', 'compare_key', 'ignore_null'],
                'title': 'Change'},
               {'properties': {'attach_related': {'type': 'boolean'},
                               'doc_type': {'type': 'string'},
                               'num_events': {'type': 'integer'},
                               'terms_size': {'type': 'integer'},
                               'timeframe': {'additionalProperties': False,
                                             'properties': {'days': {'type': 'number'},
                                                            'hours': {'type': 'number'},
                                                            'milliseconds': {'type': 'number'},
                                                            'minutes': {'type': 'number'},
                                                            'schedule': {'type': 'string'},
                                                            'seconds': {'type': 'number'},
                                                            'weeks': {'type': 'number'}},
                                             'type': 'object'},
                               'type': {'enum': ['frequency']},
                               'use_count_query': {'type': 'boolean'},
                               'use_terms_query': {'type': 'boolean'}},
                'required': ['num_events', 'timeframe'],
                'title': 'Frequency'},
               {'properties': {'alert_on_new_data': {'type': 'boolean'},
                               'doc_type': {'type': 'string'},
                               'spike_height': {'type': 'number'},
                               'spike_type': {'enum': ['up',
                                                       'down',
                                                       'both']},
                               'terms_size': {'type': 'integer'},
                               'threshold_cur': {'type': 'integer'},
                               'threshold_ref': {'type': 'integer'},
                               'timeframe': {'additionalProperties': False,
                                             'properties': {'days': {'type': 'number'},
                                                            'hours': {'type': 'number'},
                                                            'milliseconds': {'type': 'number'},
                                                            'minutes': {'type': 'number'},
                                                            'schedule': {'type': 'string'},
                                                            'seconds': {'type': 'number'},
                                                            'weeks': {'type': 'number'}},
                                             'type': 'object'},
                               'type': {'enum': ['spike']},
                               'use_count_query': {'type': 'boolean'},
                               'use_terms_query': {'type': 'boolean'}},
                'required': ['spike_height', 'spike_type', 'timeframe'],
                'title': 'Spike'},
               {'properties': {'doc_type': {'type': 'string'},
                               'threshold': {'type': 'integer'},
                               'timeframe': {'additionalProperties': False,
                                             'properties': {'days': {'type': 'number'},
                                                            'hours': {'type': 'number'},
                                                            'milliseconds': {'type': 'number'},
                                                            'minutes': {'type': 'number'},
                                                            'schedule': {'type': 'string'},
                                                            'seconds': {'type': 'number'},
                                                            'weeks': {'type': 'number'}},
                                             'type': 'object'},
                               'type': {'enum': ['flatline']},
                               'use_count_query': {'type': 'boolean'}},
                'required': ['threshold', 'timeframe'],
                'title': 'Flatline'},
               {'properties': {'alert_on_missing_field': {'type': 'boolean'},
                               'fields': {'items': {'type': ['string',
                                                             'array']},
                                          'type': ['string', 'array']},
                               'terms_size': {'type': 'integer'},
                               'terms_window_size': {'additionalProperties': False,
                                                     'properties': {'days': {'type': 'number'},
                                                                    'hours': {'type': 'number'},
                                                                    'milliseconds': {'type': 'number'},
                                                                    'minutes': {'type': 'number'},
                                                                    'schedule': {'type': 'string'},
                                                                    'seconds': {'type': 'number'},
                                                                    'weeks': {'type': 'number'}},
                                                     'type': 'object'},
                               'type': {'enum': ['new_term']},
                               'use_terms_query': {'type': 'boolean'}},
                'required': ['fields'],
                'title': 'New Term'},
               {'properties': {'cardinality_field': {'type': 'string'},
                               'max_cardinality': {'type': 'integer'},
                               'min_cardinality': {'type': 'integer'},
                               'timeframe': {'additionalProperties': False,
                                             'properties': {'days': {'type': 'number'},
                                                            'hours': {'type': 'number'},
                                                            'milliseconds': {'type': 'number'},
                                                            'minutes': {'type': 'number'},
                                                            'schedule': {'type': 'string'},
                                                            'seconds': {'type': 'number'},
                                                            'weeks': {'type': 'number'}},
                                             'type': 'object'},
                               'type': {'enum': ['cardinality']}},
                'required': ['cardinality_field', 'timeframe'],
                'title': 'Cardinality'},
               {'properties': {'metric_agg_type': {'enum': ['min',
                                                            'max',
                                                            'avg',
                                                            'sum',
                                                            'cardinality',
                                                            'value_count']},
                               'type': {'enum': ['metric_aggregation']}},
                'required': ['metric_agg_key', 'metric_agg_type'],
                'title': 'Metric Aggregation'},
               {'properties': {'type': {'enum': ['percentage_match']}},
                'required': ['match_bucket_filter'],
                'title': 'Percentage Match'},
               {'properties': {'type': {'pattern': '[.]'}},
                'title': 'Custom Rule from Module'}],
     'properties': {'aggregation': {'additionalProperties': False,
                                    'properties': {'days': {'type': 'number'},
                                                   'hours': {'type': 'number'},
                                                   'milliseconds': {'type': 'number'},
                                                   'minutes': {'type': 'number'},
                                                   'schedule': {'type': 'string'},
                                                   'seconds': {'type': 'number'},
                                                   'weeks': {'type': 'number'}},
                                    'type': 'object'},
                    'alert_text': {'type': 'string'},
                    'alert_text_args': {'items': {'type': 'string'},
                                        'type': 'array'},
                    'alert_text_kw': {'type': 'object'},
                    'alert_text_type': {'enum': ['alert_text_only',
                                                 'exclude_fields']},
                    'buffer_time': {'additionalProperties': False,
                                    'properties': {'days': {'type': 'number'},
                                                   'hours': {'type': 'number'},
                                                   'milliseconds': {'type': 'number'},
                                                   'minutes': {'type': 'number'},
                                                   'schedule': {'type': 'string'},
                                                   'seconds': {'type': 'number'},
                                                   'weeks': {'type': 'number'}},
                                    'type': 'object'},
                    'command': {'items': {'type': 'string'},
                                'type': ['string', 'array']},
                    'email': {'items': {'type': 'string'},
                              'type': ['string', 'array']},
                    'email_reply_to': {'type': 'string'},
                    'es_host': {'type': 'string'},
                    'es_password': {'type': 'string'},
                    'es_port': {'type': 'integer'},
                    'es_username': {'type': 'string'},
                    'exotel_account_sid': {'type': 'string'},
                    'exotel_auth_token': {'type': 'string'},
                    'exotel_from_number': {'type': 'string'},
                    'exotel_to_number': {'type': 'string'},
                    'exponential_realert': {'additionalProperties': False,
                                            'properties': {'days': {'type': 'number'},
                                                           'hours': {'type': 'number'},
                                                           'milliseconds': {'type': 'number'},
                                                           'minutes': {'type': 'number'},
                                                           'schedule': {'type': 'string'},
                                                           'seconds': {'type': 'number'},
                                                           'weeks': {'type': 'number'}},
                                            'type': 'object'},
                    'fail_on_non_zero_exit': {'type': 'boolean'},
                    'field': {},
                    'filter': {'additionalProperties': False,
                               'items': {},
                               'properties': {'download_dashboard': {'type': 'string'}},
                               'type': ['array', 'object']},
                    'from_addr': {'type': 'string'},
                    'generate_kibana_link': {'type': 'boolean'},
                    'gitter_msg_level': {'enum': ['info', 'error']},
                    'gitter_proxy': {'type': 'string'},
                    'gitter_webhook_url': {'type': 'string'},
                    'hipchat_auth_token': {'type': 'string'},
                    'hipchat_domain': {'type': 'string'},
                    'hipchat_from': {'type': 'string'},
                    'hipchat_ignore_ssl_errors': {'type': 'boolean'},
                    'hipchat_notify': {'type': 'boolean'},
                    'hipchat_room_id': {'type': 'string'},
                    'import': {'type': 'string'},
                    'include': {'items': {'type': 'string'},
                                'type': 'array'},
                    'index': {'type': 'string'},
                    'jira_account_file': {'type': 'string'},
                    'jira_assignee': {'type': 'string'},
                    'jira_bump_in_statuses': {'items': {'type': 'string'},
                                              'type': ['string',
                                                       'array']},
                    'jira_bump_not_in_statuses': {'items': {'type': 'string'},
                                                  'type': ['string',
                                                           'array']},
                    'jira_bump_tickets': {'type': 'boolean'},
                    'jira_component': {'items': {'type': 'string'},
                                       'type': ['string', 'array']},
                    'jira_components': {'items': {'type': 'string'},
                                        'type': ['string', 'array']},
                    'jira_issuetype': {'type': 'string'},
                    'jira_label': {'items': {'type': 'string'},
                                   'type': ['string', 'array']},
                    'jira_labels': {'items': {'type': 'string'},
                                    'type': ['string', 'array']},
                    'jira_max_age': {'type': 'number'},
                    'jira_project': {'type': 'string'},
                    'jira_server': {'type': 'string'},
                    'jira_watchers': {'items': {'type': 'string'},
                                      'type': ['string', 'array']},
                    'kibana_dashboard': {'type': 'string'},
                    'match_enhancements': {'items': {'type': 'string'},
                                           'type': 'array'},
                    'max_query_size': {'type': 'integer'},
                    'name': {'type': 'string'},
                    'notify_email': {'items': {'type': 'string'},
                                     'type': ['string', 'array']},
                    'owner': {'type': 'string'},
                    'pagerduty_client_name': {'type': 'string'},
                    'pagerduty_service_key': {'type': 'string'},
                    'pipe_match_json': {'type': 'boolean'},
                    'priority': {'type': 'integer'},
                    'query_delay': {'additionalProperties': False,
                                    'properties': {'days': {'type': 'number'},
                                                   'hours': {'type': 'number'},
                                                   'milliseconds': {'type': 'number'},
                                                   'minutes': {'type': 'number'},
                                                   'schedule': {'type': 'string'},
                                                   'seconds': {'type': 'number'},
                                                   'weeks': {'type': 'number'}},
                                    'type': 'object'},
                    'query_key': {'items': {'type': 'string'},
                                  'type': ['string', 'array']},
                    'raw_count_keys': {'type': 'boolean'},
                    'realert': {'additionalProperties': False,
                                'properties': {'days': {'type': 'number'},
                                               'hours': {'type': 'number'},
                                               'milliseconds': {'type': 'number'},
                                               'minutes': {'type': 'number'},
                                               'schedule': {'type': 'string'},
                                               'seconds': {'type': 'number'},
                                               'weeks': {'type': 'number'}},
                                'type': 'object'},
                    'replace_dots_in_field_names': {'type': 'boolean'},
                    'simple_proxy': {'type': 'string'},
                    'simple_webhook_url': {'items': {'type': 'string'},
                                           'type': ['string', 'array']},
                    'slack_emoji_override': {'type': 'string'},
                    'slack_icon_url_override': {'type': 'string'},
                    'slack_msg_color': {'enum': ['good',
                                                 'warning',
                                                 'danger']},
                    'slack_parse_override': {'enum': ['none', 'full']},
                    'slack_text_string': {'type': 'string'},
                    'slack_username_override': {'type': 'string'},
                    'slack_webhook_url': {'items': {'type': 'string'},
                                          'type': ['string', 'array']},
                    'smtp_host': {'type': 'string'},
                    'telegram_api_url': {'type': 'string'},
                    'telegram_bot_token': {'type': 'string'},
                    'telegram_room_id': {'type': 'string'},
                    'timestamp_field': {'type': 'string'},
                    'top_count_keys': {'items': {'type': 'string'},
                                       'type': 'array'},
                    'top_count_number': {'type': 'integer'},
                    'twilio_accout_sid': {'type': 'string'},
                    'twilio_auth_token': {'type': 'string'},
                    'twilio_from_number': {'type': 'string'},
                    'twilio_to_number': {'type': 'string'},
                    'use_kibana_dashboard': {'type': 'string'},
                    'use_local_time': {'type': 'boolean'},
                    'use_ssl': {'type': 'boolean'},
                    'use_strftime_index': {'type': 'boolean'},
                    'verify_certs': {'type': 'boolean'},
                    'victorops_api_key': {'type': 'string'},
                    'victorops_entity_display_name': {'type': 'string'},
                    'victorops_message_type': {'enum': ['INFO',
                                                        'WARNING',
                                                        'ACKNOWLEDGEMENT',
                                                        'CRITICAL',
                                                        'RECOVERY']},
                    'victorops_routing_key': {'type': 'string'}},
     'required': ['type', 'index', 'alert'],
     'type': 'object'}

On instance:
    {'alert': ['email'],
     'email': ['prayag.x@gmail.com'],
     'filter': [{'query': {'query_string': {'query': '"ERROR"'}}}],
     'index': 'filebeat-*',
     'name': 'Error alert rule',
     'num_events': 1,
     'rule_file': '/etc/alert_rules/errors.yaml',
     'type': 'frequency'}

```

