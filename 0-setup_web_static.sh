#!/usr/bin/env bash
# This script sets up a web server for the deployment of web_static

# Install Nginx if not already installed
if ! dpkg -l | grep -q nginx; then
    apt-get update
    apt-get install -y nginx
fi

# Create the required directories
mkdir -p /data/web_static/releases/test
mkdir -p /data/web_static/shared

# Create a fake HTML file
echo "<html>
  <head>
    <title>Test Page</title>
  </head>
  <body>
    <h1>Hello World!</h1>
  </body>
</html>" > /data/web_static/releases/test/index.html

# Remove the old symbolic link if it exists and create a new one
if [ -L /data/web_static/current ]; then
    rm /data/web_static/current
fi
ln -s /data/web_static/releases/test /data/web_static/current

# Change ownership of the /data/ folder to ubuntu user and group
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
NGINX_CONF="/etc/nginx/sites-available/default"

# Backup the existing configuration
cp $NGINX_CONF ${NGINX_CONF}.bak

# Update the configuration file
sed -i '/location \/ {/a \\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' $NGINX_CONF

# Restart Nginx to apply changes
systemctl restart nginx

exit 0
