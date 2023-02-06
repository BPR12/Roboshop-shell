source common.sh

print_head "Disable MySQL Default Module"
dnf module disable mysql -y &>>${LOG}
status_check


print_head "Copy MySQL Repo File"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install MySQL"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable MySQL"
systemctl enable mysql &>>${LOG}
status_check

print_head "Restart MySQL"
systemctl restart mysql &>>${LOG}
status_check