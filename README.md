# Time Management CI PoC
CI for the TM application, ubuntu based NodeJS server

## Provision OpenStack infra
You can use ENV variables for OpenStack access.
```
terraform init ; plan ; apply
```

## Prepare NodeJS server
```
$ ansible-playbook -i dreamcompute.inv time-management/ansible/install_nodejsserver.yml
```
## Install docker, optionally deploy and run docker image from file
```
$ ansible-playbook -i dreamcompute.inv time-management/ansible/install_docker.yml
$ ansible-playbook -i dreamcompute.inv time-management/ansible/install_docker.yml -e app=docker-image.tar.gz
```

## Prepare CI server (Jenkins)
```
$ ansible-playbook --key ~/.ssh/dreamcompute.pem  -i dreamcompute.inv time-management/ansible/install_jenkins.yml
```
Generate keys for repository access and load to your repositories deployment keys section
```
$ sudo cat jenkins/.ssh/id_rsa.pub

https://github.com/tite-alvarado/timeoff-management-application/settings/keys
```
Load jobs for CI

# time-management
Jenkins job provides building, testing and packging in a docker image.
