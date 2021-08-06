# Time Management CI PoC
CI for the TM application, ubuntu based NodeJS server

## Small Infrastructure diagram

<img width="374" alt="Screen Shot 2021-08-05 at 9 23 23 PM" src="https://user-images.githubusercontent.com/17421586/128451378-f3372846-0d34-45cc-843f-a5e6ef17ce62.png">


## Provision OpenStack infra
You can use ENV variables for OpenStack access.
```
terraform init ; plan ; apply
```

## Prepare NodeJS server, deploy NodeJS application
```
$ ansible-playbook -i inventory time-management/ansible/install_nodejsserver.yml
$ ansible-playbook -i inventory time-management/ansible/install_nodejsserver.yml -e app=timeoff-management-application_master_64.tar -e app_port=3030
```
## Install docker, optionally deploy and run docker image from file
Note: NodeJS base image broken for sqlite support
```
$ ansible-playbook -i inventory time-management/ansible/install_docker.yml
$ ansible-playbook -i inventory time-management/ansible/install_docker.yml -e app=docker-image.tar.gz
```

## Prepare NGINX Load Balancer
```
$ ansible-playbook -i inventory time-management/ansible/install_nginx.yml
```
Review `time-management` backend and add your nodejs application instances

## Prepare CI server (Jenkins)
```
$ ansible-playbook --key ~/.ssh/dreamcompute.pem  -i inventory time-management/ansible/install_jenkins.yml
```
Generate keys for repository access and load to your repositories deployment keys section
```
$ sudo cat jenkins/.ssh/id_rsa.pub
https://github.com/tite-alvarado/timeoff-management-application/settings/keys
```
Load jobs for CI

# time-management
Jenkins job provides building, testing and packging in a docker image.
