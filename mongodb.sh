#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%S-%M-%H)
LOGFILE="/tmp/$0-TIMESTAMP.log"

ID=$(id -u)

if [ $ID -ne 0 ]
  then 
      echo -e "ERROR:$R Root user access denied $N"
else
      echo -e "You are the $Y root user $N"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
      then 
          echo "ERROR: $2 ...failed!!"
    else
          echo "$2 ....successed!!"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

cp mongo.repo /etc/yum.repos.d/ -y &>>LOGFILE

VALIDATE $? "Mongodb.repo Copyied!!"

dnf install mongodb-org -y &>>LOGFILE

VALIDATE $? "mongodb-org dependincy installed!!"

systemctl enable mongod -y &>>LOGFILE

VALIDATE $? "mongod enabled successfully!!"

systemctl start mongod -y &>>LOGFILE

VALIDATE $? "mongod enabled successfully!!"