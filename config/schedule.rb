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

env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

every 1.minute do
	runner "Car.alerta()"
end

every 1.day, :at => '2:30 am' do
	runner "Car.chileautos_crawler('terrano')"
end

every 1.day, :at => '2:40 am' do
	runner "Car.chileautos_crawler('l200')"
end

every 1.day, :at => '2:50 am' do
	runner "Car.chileautos_crawler('dmax')"
end

every 1.day, :at => '3:00 am' do
	runner "Car.chileautos_crawler('amarok')"
end

every 1.day, :at => '3:10 am' do
	runner "Car.chileautos_crawler('ranger')"
end

every 1.day, :at => '3:20 am' do
	runner "Car.chileautos_crawler('navara')"
end

every 1.day, :at => '3:30 am' do
	runner "Car.chileautos_crawler('hilux')"
end

every 1.day, :at => '3:40 am' do
	runner "Car.chileautos_crawler('montana')"
end

every 1.day, :at => '3:50 am' do
	runner "Car.chileautos_crawler('straada')"
end

every 1.day, :at => '4:00 am' do
	runner "Car.chileautos_crawler('saveiro')"
end

every 1.day, :at => '4:10 am' do
	runner "Car.chileautos_crawler('fiorino')"
end

every 1.day, :at => '4:20 am' do
	runner "Car.chileautos_crawler('partner')"
end

every 1.day, :at => '4:30 am' do
	runner "Car.chileautos_crawler('bipper')"
end

every 1.day, :at => '4:40 am' do
	runner "Car.chileautos_crawler('berlingo')"
end

every 1.day, :at => '4:50 am' do
	runner "Car.chileautos_crawler('kangoo')"
end

every 1.day, :at => '5:00 am' do
	runner "Car.chileautos_crawler('doblo')"
end