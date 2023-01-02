COMPONENT=mongodb
source common.sh
RABBITMQ_APP_USER_PASSWORD=$1

if [ -z "$1"]; then
  echo "Input Password is Missing"
  exit
fi

PRINT "Configure Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Instal  Erlang"
yum install erlang -y
STAT $?

PRINT "Configure RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install RabbitMQ"
yum install rabbitmq-server -y &>>$LOG
STAT $?

PRINT "Enable RabbitMQ Service"
systemctl enable rabbitmq-server &>>$LOG
STAT $?

PRINT "Start RabbitMQ Service"
systemctl restart rabbitmq-server &>>$LOG
STAT $?

PRINT "Add Application User"
rabbitmqctl add_user roboshop ${RABBITMQ_APP_USER_PASSWORD} &>>$LOG
STAT $?

PRINT "Configure Application User Tags"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG
STAT $?

PRINT "Configure Application User Permission"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
STAT $?