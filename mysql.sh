curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
dnf module disable mysql -y

yum install mysql-community-server -y

systemctl enable mysqld
systemctl restart mysqld

echo "ALTER USER 'root'@'locaihost' IDENTIFIED BY 'RoboShop@1';" > /tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')