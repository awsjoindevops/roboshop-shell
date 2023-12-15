#!/bin/bash

ID=$(id -u)


R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at  $TIMESTAMP"  &>>$LOGFILE

#VALIDATE METHOD
VALIDATE(){

 if [ $1 -ne 0 ]
        then
        echo  -e " $R ERROR :  $2 is -------FAILED $N"
        exit 1

        else
        echo  -e "$G $2 is ------- SUCCESS $N"
        fi
}

if [ $ID -ne 0 ] 
then
    echo "Error please run this script with root access"
    exit 1  # you can give other than 0
else
    echo "you are root user"
fi



curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "DOwnload erlang"


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "downloadrabbitmq script"


dnf install rabbitmq-server -y &>>$LOGFILE
VALIDATE $? "Install rabbbitmq server"


systemctl enable rabbitmq-server &>>$LOGFILE
VALIDATE $? "enable rabbitmq"


systemctl start rabbitmq-server &>>$LOGFILE
VALIDATE $? "start rabbit mq"


rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
VALIDATE $? "create user"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
VALIDATE $? "settign permissions"
