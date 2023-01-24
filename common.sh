script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
if [ $? -eq 0 ] ; then
  echo -e "\1;e[32m SUCCESS\e[0m"
else
  echo -e "\1;e[31m FAILURE\e[0m"
  exit
fi
}
