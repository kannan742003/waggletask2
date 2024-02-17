#!/bin/bash

# Set environment variables
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set full paths
mysqldump_cmd=/usr/bin/mysqldump
python_cmd=/usr/bin/python3
send_email_script=/home/ubuntu/backup/send_email.py

# MySQL credentials
username="kannan"
password="kannan@07"
database_name="newone"

# Backup directory
backup_dir="/var/log/mysql"

# Ensure backup directory exists
mkdir -p "$backup_dir"

# Backup filename
backup_file="$backup_dir/mysql_backup_$(date +'%Y-%m-%d_%H-%M-%S').sql"

# Perform MySQL backup
"$mysqldump_cmd" -u "$username" -p"$password" "$database_name" > "$backup_file"
backup_status=$?

# Check if backup was successful and send email notification
if [ $backup_status -eq 0 ]; then
    "$python_cmd" "$send_email_script" "MySQL Backup Successful" "Backup of MySQL database '$database_name' was successful."
else
    "$python_cmd" "$send_email_script" "MySQL Backup Failed" "Backup of MySQL database '$database_name' failed."
fi

