```
# ansible command
ansible-playbook -vvvv -i ansible/inventory.ini \
  --extra-vars "@extra-vars.yml" \
  ansible/playbooks/playbook-all.yml

# tree site/

site/
├── production.yml
├── stage.yml
├── dev.yml
├── site.yml
├── common.yml
├── infra.yml
├── application.yml
├── system.yml
├── group_vars
│   ├── all
│   ├── common
│   ├── infra
│   │   ├── apigateway
│   │   ├── messages
│   │   ├── mail
│   │   ├── kubernetes
│   │   └── log
│   ├── application
│   │   ├── web
│   │   ├── ap
│   │   ├── batch
│   │   ├── cache
│   │   └── database
│   ├── system
│   │   ├── elasticsearch
│   │   ├── nagios
│   │   ├── jenkins
│   │   └── gitbuck
│   └── templates
├── inventory
│   ├── common
│   ├── system
│   ├── infra
│   ├── application
│   └── templates
└── roles
     ├── common
     ├── web
     ├── ap
     ├── batch
     ├── cache
     ├── database
     ├── apigateway
     ├── messages
     ├── mail
     ├── kubernetes
     ├── log
     ├── elasticsearch
     ├── nagios
     ├── jenkins
     ├── gitbuck
     └── templates
          ├── tasks
          │   └── main.yml
          ├── handlers
          │   └── main.yml
          ├── templates
          │   └── ntp.conf.j2
          ├── files
          │   ├── foo.sh
          │   └── bar.txt
          ├── handlers
          │   └── main.yml
          ├── vars
          │   └── main.yml
          ├── defaults
          │   └── main.yml
          └── meta
               └── main.yml

```
