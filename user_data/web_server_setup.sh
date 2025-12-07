#!/bin/bash
# Log output (useful for debugging)
exec > /var/log/user-data.log 2>&1

echo "Starting Apache installation..."

# Retry yum until NAT gateway is ready and yum works
until yum update -y; do
  echo "YUM update failed -- retrying in 5 seconds..."
  sleep 5
done

until yum install -y httpd; do
  echo "YUM install failed -- retrying in 5 seconds..."
  sleep 5
done

# Enable and start Apache
systemctl enable httpd
systemctl start httpd

# Fetch the instance ID to display on the webpage
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Create a simple HTML page
cat <<EOF > /var/www/html/index.html
<html>
  <head>
    <title>TechCorp Web Server</title>
  </head>
  <body style="font-family: Arial; text-align: center; margin-top: 50px;">
    <h1>Welcome to TechCorp Web Server!</h1>
    <h2>Instance ID: $INSTANCE_ID</h2>
    <p>This page is served from a private subnet EC2 instance.</p>
  </body>
</html>
EOF

echo "Apache setup complete!"
# End of script