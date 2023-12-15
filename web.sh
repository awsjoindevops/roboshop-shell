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



dnf install nginx -y &>> $LOGFILE
VALIDATE $? "install nginx"


systemctl enable nginx &>> $LOGFILE
VALIDATE $? "enable nginx"


systemctl start nginx &>> $LOGFILE
VALIDATE $? "start nginx"


#http://<public-IP>:80


rm -rf /usr/share/nginx/html/*  &>> $LOGFILE
VALIDATE $? "remove default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip  &>> $LOGFILE
VALIDATE $? "download web application"


cd /usr/share/nginx/html  &>> $LOGFILE
VALIDATE $? "move to html dir"

unzip /tmp/web.zip  &>> $LOGFILE
VALIDATE $? "unzip web"


cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
 VALIDATE $? "copy the roshop reverse proxy  config"


systemctl restart nginx  &>> $LOGFILE
VALIDATE $? "restart nginx"
