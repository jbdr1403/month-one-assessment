#!/bin/bash
# Update system
yum update -y

# Enable and install PostgreSQL 14
amazon-linux-extras install postgresql14 -y
yum install postgresql-server postgresql-contrib -y

# Initialize database
/usr/bin/postgresql-setup initdb

# Enable and start service
systemctl enable postgresql
systemctl start postgresql
