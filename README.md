# sagittariusSEC

This repository is stale and only serves as public archive for my master thesis. However, rules developed for the thesis serve as a base for frankenstack correlator. Please see [this repo](https://github.com/ccdcoe/frankenSEC) for more up-to-date version of the rules.

## Old readme

This SEC ruleset is designed to indentify common attack patterns from server log files. Currently, it supports identification of authentication attacks from various services, general web application injections and some forms of DNS amplification attacks.

NOTE: Please edit action.sec file to match your environment.

```
pattern=\S*(?:192\\.168\\.\d{1,3}\\.\d{1,3})
```
For example if your internal network uses 10.0.0.0/8 range then use the following regular expression:
```
pattern=\S*(?:10(?:\\.\d{1,3}){3})
```

### Simple deployment

```
cd /opt
git pull https://github.com/markuskont/SagittariuSEC
sec --detach --conf=/opt/SagittariuSEC/rules/\*.sec --input=/var/log/\*.log --syslog=daemon
```

Rules in actions.sec file can be used to block attackers in real time. Some basic scripts for that are provided in Scripts folder. These scripts can be executed over key-based SSH connection on central firewall.

```
vim /opt/SagittariuSEC/rules/actions.sec
```
```
action=logonly; event IP_BLOCKED_$+{remote_IP}; shellcmd (ssh root@firewall.domain.ex 'bash -s' -- <  /opt/SagittariuSEC/scripts/iptables.sh $+{remote_IP}
```

Simple ruleset update, custom actions will be preserved

```
cd /opt/SagittariuSEC/
mv rules/actions.sec /tmp/ && git pull && mv /tmp/actions.sec rules/
```
