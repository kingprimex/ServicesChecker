#!/bin/bash


http_uptime=$(/usr/sbin/httpd fullstatus | grep uptime | awk '{print $3" " $4" " $5" " $6" "  $7" "  $8" "  $9" " $10}')

mysql_uptime=$(/usr/bin/mysqladmin version | grep Uptime | awk '{print $2" " $3" " $4" " $5" " $6" " $7" " $8" " $9}')

smtp_imap_uptime=$(ps -eo pid,comm,lstart,etime,time,args --sort=start_time | grep exim  | head -n 1| awk '{print $8}')

if [[ $smtp_imap_uptime == [0-9][0-9]:[0-9][0-9] ]]
then
smtp_minutes=$(echo $smtp_imap_uptime | awk -F":" '{print $1}')
smtp_seconds=$(echo $smtp_imap_uptime | awk -F":" '{print $2}')
mail_uptime="$smtp_minutes minutes $smtp_seconds seconds"
elif [[ $smtp_imap_uptime == [0-9][0-9]:[0-9][0-9]:[0-9][0-9] ]]
then
smtp_hours=$(echo $smtp_imap_uptime | awk -F":" '{print $1}')
smtp_minutes=$(echo $smtp_imap_uptime | awk -F":" '{print $2}')
smtp_seconds=$(echo $smtp_imap_uptime | awk -F":" '{print $3}')
mail_uptime="$smtp_hours hours $smtp_minutes minutes $smtp_seconds seconds"
else
smtp_days=$(echo $smtp_imap_uptime | awk -F"-" '{print $1}')
smtp_hours=$(echo $smtp_imap_uptime | awk -F"-" '{print $2}' | awk -F":" '{print $1}')
smtp_minutes=$(echo $smtp_imap_uptime | awk -F"-" '{print $2}' | awk -F":" '{print $2}')
smtp_seconds=$(echo $smtp_imap_uptime | awk -F"-" '{print $2}' | awk -F":" '{print $3}')
mail_uptime="$smtp_days days $smtp_hours hours $smtp_minutes minutes $smtp_seconds seconds"
fi

mail_file="/tmp/mail.txt"
echo "HTTP server uptime:" >>$mail_file
echo $http_uptime >> $mail_file
echo "\n" >> $mail_file

echo "MYSQL server uptime:" >>$mail_file
echo $mysql_uptime >> $mail_file
echo "\n" >> $mail_file

echo "EXIM  server uptime:" >>$mail_file
echo $mail_uptime >> $mail_file
echo "\n" >> $mail_file
msg=$(cat $mail_file)

echo -e "$msg" | mail -s "Services Status" user@grr.com

rm $mail_file

 
