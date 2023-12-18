#!/bin/bash
ID=$(id -u)
R="\e[30m"
G="\e[31m"
Y="\E[32M"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%S-%R)
LOGFILE=/tmp/$0-$TIMESTAMP.log
echo "script starting $TIMESTAMP" &>> LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
      then 
          echo -e "$2 $R ..Failed!! $N"
          EXIT 1
    else 
          echo -e "$2 $G ..Success!! $N"
    fi
}

if [ id -ne 0 ]
  then
      echo -e "$Y Please log as a $R Root User $N"
else
      echo -e "$Y U are D $G Root $Y Usr $N"
fi

dnf module disable nodejs -y &>> LOGFILE
VALIDATE $? "module disble  nodejs"


dnf module enable nodejs:18 -y &>> LOGFILE
VALIDATE $? "module enable  nodejs"

dnf install nodejs -y &>> LOGFILE
VALIDATE $? "Inatlled nodejs"

useradd roboshop &>> LOGFILE
VALIDATE $? "roboshop useradded"

mkdir /app &>> LOGFILE
VALIDATE $? "app dir created"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> LOGFILE

VALIDATE $? "Downloading Catalouge"

cd /app &>> LOGFILE
VALIDATE $? "Enter to the app dir"

unzip /tmp/catalogue.zip &>> LOGFILE
VALIDATE $? "unzipiing the catalogue"

cd /app

npm install &>>LOGFILE
VALIDATE $? "npm installed"


cp catalogue.service /etc/systemd/system/catalogue.service &>>LOGFILE
VALIDATE $? "Copied"


systemctl daemon-reload &>>LOGFILE
VALIDATE $? "Daemon reloaded"


systemctl enable catalogue &>>LOGFILE
VALIDATE $? "catalogue enabled"

systemctl start catalogue &>>LOGFILE
VALIDATE $? "catalouge started"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGFILE
VALIDATE $? "copied"

dnf install mongodb-org-shell -y &>>LOGFILE
VALIDATE $? "installed mongod-org-shell"

mongo --host mongodb.devopsrk.cloud </app/schema/catalogue.js &>>LOGFILE
VALIDATE $? "hosted"