COMPONENT=cart
source common.sh

PRINT "Install NodeJs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
STAT $?

PRINT "Install NodeJs"
yum install nodejs -y &>>$LOG
STAT $?

PRINT "Adding Application User"
id roboshop &>>$LOG
if [ $? -ne 0 ]; then
  useradd roboshop &>>$LOG
fi
STAT $?

PRINT "Download App Content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
STAT $?

PRINT "Remove Previous Version of App"
cd /home/roboshop &>>$LOG
rm -rf cart &>>$LOG
STAT $?

PRINT "Extracting App Content"
unzip -o /tmp/cart.zip &>>$LOG
STAT $?

mv cart-main cart
cd cart

PRINT "Install NODEJS Dependencies for App"
npm install &>>$LOG
STAT $?

PRINT "Configure Endpoints for SystemD configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' /home/roboshop/cart/systemd.service
STAT $?

PRINT "Setup SystemD Properties"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
STAT $?

PRINT "Reload SustemD"
systemctl daemon-reload &>>$LOG
STAT $?

PRINT "Restart Cart"
systemctl restart cart &>>$LOG
STAT $?

PRINT "Enable Cart"
systemctl enable cart &>>$LOG
STAT $?