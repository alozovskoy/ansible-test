#!/usr/bin/env python

import requests
import json
import sys

zabbixServerURL = sys.argv[1]
zabbixCurrentPass = sys.argv[2]
zabbixNewPass = sys.argv[3]

url = 'http://' + zabbixServerURL + '/zabbix/api_jsonrpc.php'
headers = {"Content-Type": "application/json-rpc"}

loginRequest = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password": zabbixCurrentPass
    },
    "id": 1,
    "auth": None
}

resp = requests.post(url, data=json.dumps(loginRequest), headers=headers)

if resp.status_code == 200:
    token = json.loads(resp.text)['result']
else:
    print "Auth error"
    exit(1)

templateRequest = {
    "jsonrpc": "2.0",
    "method": "template.get",
    "params": {
        "filter": {
            "host": [
                "Template OS Linux",
            ]
        }
    },
    "auth": token,
    "id": 2
}

resp = requests.post(url, data=json.dumps(templateRequest), headers=headers)
if resp.status_code == 200:
    data = json.loads(resp.text)
    for template in data['result']:
        if template['name'] == 'Template OS Linux':
            templateID = template['templateid']
else:
    print "Templates get error"
    exit(1)

actionRequest = {
    "jsonrpc": "2.0",
    "method": "action.create",
    "params": {
        "name": "Auto add hosts",
        "eventsource": 2,
        "status": 0,
        "esc_period": 120,
        "def_shortdata": "Auto registration: {HOST.HOST}",
        "def_longdata": "Host name: {HOST.HOST}\nHost IP: {HOST.IP}\nAgent port: {HOST.PORT}",
        "filter": {
            "evaltype": 0,
            "conditions": [
                {
                    "conditiontype": 24,
                    "operator": 2,
                    "value": "Linux"
                },
            ]
        },
        "operations": [
            {
                "operationtype": 2,
            },
            {
                "operationtype": 6,
                "optemplate": [{
                    "templateid": templateID
                }]
            },
        ]
    },
    "auth": token,
    "id": 3
}

resp = requests.post(url, data=json.dumps(actionRequest), headers=headers)
if resp.status_code != 200:
    print "Action Add error"
    exit(1)

passwordRequest = {
    "jsonrpc": "2.0",
    "method": "user.update",
    "params": {
        "userid": "1",
        "passwd": zabbixNewPass,
    },
    "auth": token,
    "id": 4
}

resp = requests.post(url, data=json.dumps(passwordRequest), headers=headers)
if resp.status_code != 200:
    print "Password change error"
    exit(1)
