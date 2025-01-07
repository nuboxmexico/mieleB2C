# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Uptade  whenever --update-crontab --set environment=development
#  whenever --update-crontab --set environment=production


env :PATH, ENV['PATH']

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
set :path, Rails.root
set :output, 'log/whenever.log'

# tarea que envia correo a clientes con carrito abandonado
#every :day, at: '8:00 am' do
#	rake 'recover_carts'
#end

every 1.day, at: '5:00 am' do
  rake '-s sitemap:refresh'
end

# tarea que semanalmente sincroniza los products del B2C con los de Miele Core
every :sunday, at: '5:00am' do
	rake 'synchronize_miele_core_products'
end