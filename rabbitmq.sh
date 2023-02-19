source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "variable roboshop_rabbitmq_password is missing"
  exit
fi

print_head "Configuring Erlang YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Configuring RabbitMQ YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install Erlang & RabbitMQ"
yum install erlang -y rabbitmq-server -y &>>${LOG}
status_check

print_head "Enable RabbitMQ server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "Start RabbitMQ server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? ne 0 ]; then
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
status_check

print_head "Add Tags To Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print_head "Add Permissions To Application User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check