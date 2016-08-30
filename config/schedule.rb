env :PATH, '/home/deploy/.gem/ruby/2.3.0'
env :GEM_PATH, '/home/deploy/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0'

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