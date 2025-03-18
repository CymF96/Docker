#!/bin/bash

# Wait to ensure the volume is mounted
sleep 2

cd /var/www/cofische || { echo "Failed to change directory!"; exit 1; }

if [ ! -f /tmp/wp-config.php ]; then
	echo "wp-config.php not found"

else

	mv /tmp/wp-config.php /var/www/cofische/wp-config.php
	chown -R www-data:www-data /var/www/cofische/wp-config.php && chmod +x /var/www/cofische/wp-config.php
	# Debugging: Check if the directory exists before proceeding
	echo "Checking if /var/www/cofische exists..."
	echo "inside /var/www/cofische: " && ls -ld /var/www/cofische || echo "Directory not found!"
	if ! wp core is-installed; then
		wp core install --allow-root \
			--url="$SITE_URL" \
			--title="$SITE_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--admin_password="$WP_ADMIN_PASSWORD" \
			--admin_email="$WP_ADMIN_EMAIL" \
			
	fi

	echo "wordpress installation completed"

fi

exec "$@"
