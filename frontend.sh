script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
  if [ $? -eq 0 ] ; then
    echo -e "\e[32m SUCCESS\e[0m"
  else
    echo -e "\e[31m FAILURE\e[0m"
  fi
  }


echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}
status_check

echo -e "\e[35m Remove Nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check


echo -e "\e[35m Download Front end content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[35m Extract Front end content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
status_check


echo -e "\e[35m Copy Nginx Config File\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

echo -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}
status_check

echo -e "\e[35m Restart Nginx\e[0m"
systemctl restart nginx &>>${LOG}
status_check

