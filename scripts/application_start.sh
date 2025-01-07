#!/bin/bash
echo "Running application_start hook"
# Source RVM
source ~/.rvm/bin/rvm
cd /var/www/html/miele-b2c/current
rvm use 2.6.10
# Set folder permissions
sudo chown -R www-data:www-data /var/www/html/miele-b2c/current
sudo chown -R ubuntu:ubuntu /var/www/html/miele-b2c/current
sudo chmod -R 755 /var/www/html/miele-b2c/current
sudo chown -R ubuntu:ubuntu /var/www/html/miele-b2c/current/log
sudo chmod -R 750 /var/www/html/miele-b2c/current/log
sudo chown -R ubuntu:ubuntu /var/www/html/miele-b2c/current/tmp
sudo chmod -R 770 /var/www/html/miele-b2c/current/tmp
sudo chown -R ubuntu:ubuntu /var/www/html/miele-b2c/current/public/uploads
sudo chmod -R 750 /var/www/html/miele-b2c/current/public/uploads
sudo chown -R ubuntu:ubuntu /var/www/html/miele-b2c/current/.bundle
sudo chmod -R 755 /var/www/html/miele-b2c/current/.bundle
# bundle
bundle install --deployment --without development test
bundle exec rake assets:precompile RAILS_ENV=$DEPLOYMENT_GROUP_NAME
if [ "$DEPLOYMENT_GROUP_NAME" == "production" ]
then
    bundle exec rake assets:sync RAILS_ENV=$DEPLOYMENT_GROUP_NAME # Synchronize assets using asset_sync
fi
bundle exec rake db:migrate RAILS_ENV=$DEPLOYMENT_GROUP_NAME
if [ "$DEPLOYMENT_GROUP_NAME" == "production" ] 
then
    sudo service nginx reload
else
    sudo service apache2 restart
fi



