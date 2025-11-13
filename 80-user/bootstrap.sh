#installing ansible in the mongodb 

component=$1
dnf install -y ansible git
ansible-pull -U https://github.com/daws-84s/ansible-roboshop-roles-tf.git -e component=$1 -e env=$2 main.yaml