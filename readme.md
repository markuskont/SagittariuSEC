This SEC ruleset is designed to indentify common attack patterns from server log files. Currently, it supports identification of authentication attacks from various services, general web application injections and some forms of DNS amplification attacks.

NOTE: Please edit action.sec file to match your environment.

pattern=\S*(?:192\\.168\\.\d{1,3}\\.\d{1,3})

For example if your internal network uses 10.0.0.0/8 range then use the following regular expression:

pattern=\S*(?:10(?:\\.\d{1,3}){3})

Simple deployment

cd /opt

git pull https://github.com/markuskont/SagittariuSEC

sec --detach --conf=/opt/SagittariuSEC/rules/*.sec --input=/var/log/*.log --syslog=daemon

Simple ruleset update, custom actions will be preserved

cd /opt/SagittariuSEC/

mv rules/actions.sec /tmp/ && git pull && mv /tmp/actions.sec rules/