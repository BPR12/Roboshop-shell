script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
if [ $? -eq 0 ] ; then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo -e "\e[31m FAILURE\e[0m"
  exit
fi
}
print_head() {
echo -e "\e[35m $1\e[0m"
}