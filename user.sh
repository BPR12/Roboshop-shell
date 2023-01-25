source common.sh

print_head "Configuring NodeJs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add Application user"
if [ $? -ne 0 ]; then
id roboshop &>>${LOG}
  useradd roboshop &>>${LOG}
fi
status_check

mkdir -p /app &>>${LOG}

print_head "Downloading App Content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "Cleanup Old Content"
rm -rf /app/* &>>${LOG}
status_check

cd /app

print_head "Extracting App Content"
unzip /tmp/user.zip &>>${LOG}
status_check

cd /app

print_head "Installing NodeJs Dependencies"
npm install &>>${LOG}
status_check

print_head "Configuring user Service File"
cp ${script_location}/files/user.service /etc/systemd/system/user.service &>>${LOG}
status_check

print_head "Reload systemD"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable user"
systemctl enable user &>>${LOG}
status_check

print_head "Start user Service"
systemctl start user &>>${LOG}
status_check

print_head "Configuring Mongo Repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.devops22.online</app/schema/user.js &>>${LOG}
status_check