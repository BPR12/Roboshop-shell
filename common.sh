script_location=$(pwd)

LOG=/tmp/roboshop.log

status_check() {
if [ $? -eq 0 ] ; then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo -e "\e[31m FAILURE\e[0m"
  echo "Refer Log file for more information, LOG - $LOG"
  exit
fi
}

print_head() {
echo -e "\e[35m $1\e[0m"
}

APP_PREREQ() {

  print_head "Add Application user"
    id roboshop &>>${LOG}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${LOG}
    fi
    status_check

    mkdir -p /app &>>${LOG}

    print_head "Downloading App Content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
    status_check

    print_head "Cleanup Old Content"
    rm -rf /app/* &>>${LOG}
    status_check

    print_head "Extracting App Content"
    cd /app
    unzip /tmp/${component}.zip &>>${LOG}
    status_check


}
NODEJS() {
  print_head "Configuring NodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install NodeJs"
  yum install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Installing NodeJs Dependencies"
  npm install &>>${LOG}
  status_check

  print_head "Configuring ${component} Service File"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Reload systemD"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Enable ${component}"
  systemctl enable ${component} &>>${LOG}
  status_check

  print_head "Start ${component} Service"
  systemctl start ${component} &>>${LOG}
  status_check

if [ ${schema_load} == "true" ]; then
  print_head "Configuring Mongo Repo"
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
  status_check

  print_head "Install Mongo Client"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

  print_head "Load Schema"
  mongo --host mongodb-dev.devops22.online</app/schema/${component}.js &>>${LOG}
  status_check
fi
}

MAVEN() {

   print_head "Install Maven"
    yum install maven -y &>>${LOG}
    status_check

   APP_PREREQ

   print_head "Build a Package"
   yum mvn clean package &>>${LOG}
   status_check

   print_head "Copy App file to App Location"
   mv target/${component}-1.0.jar ${component}.jar  &>>${LOG}
   status_check

}
