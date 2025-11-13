#installing ansible in the mongodb 

component=$1
dnf install -y ansible git
ansible-pull -U git@github.com:daws-84s/ansible-roboshop-roles.tf.git -e component=$1 -e  env=$2 main.yaml


# Installing and configuring MongoDB
# This section will install and configure MongoDB using Ansible
# The Ansible playbook will be pulled from the specified Git repository
# ansible-pull will be used to execute the playbook
# This allows for easy configuration management and deployment
# The playbook will be executed on the target host
# The Ansible roles and tasks defined in the playbook will be applied to the MongoDB instance

# bootstrap means configuration 