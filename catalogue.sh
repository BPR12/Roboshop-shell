source common.sh

print_head "Configuring NodeJs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add Application user"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app &>>${LOG}

echo -e "\e[35m Downloading App Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m Cleanup Old Content\e[0m"
rm -rf /app/* &>>${LOG}
status_check

cd /app

echo -e "\e[35m Extarcting App Content\e[0m"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

cd /app

echo -e "\e[35m Installing NodeJs Dependencies\e[0m"
npm install &>>${LOG}
status_check

echo -e "\e[35m Configuring Catalogue Service File\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e "\e[35m Reload systemD\e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[35m enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[35m Start CatalogueService\e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[35m Configuring Mongo Repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

echo -e "\e[35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[35m Load Schema\e[0m"
mongo --host mongodb-dev.devops22.online</app/schema/catalogue.js &>>${LOG}
status_check