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




dnf install maven -y &>> $LOGFILE
VALIDATE $? "Install maven"



id roboshop
if [ $? -ne 0 ]  
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "add roboshop"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Create APP Directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "Download application code"

cd /app &>> $LOGFILE
VALIDATE $? "NAVIGATE TO APP directory"

unzip /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "unzip catalogue"

cd /app &>> $LOGFILE
VALIDATE $? "NAVIGATE TO APP dirGectory 2"


mvn clean package &>> $LOGFILE
VALIDATE $? "MVN Clean"


mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
VALIDATE $? "MOVING" 

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "Copying the catalogue to services"


systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reload"

systemctl enable shipping  &>> $LOGFILE
VALIDATE $? "Enable shipping"

systemctl start shipping &>> $LOGFILE
VALIDATE $? "start shipping"

dnf install mysql -y &>> $LOGFILE
VALIDATE $? "Install mysql"



mysql -h mysql.awsjoindevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 



systemctl restart shipping &>> $LOGFILE
VALIDATE $? "Restart Shipping"




