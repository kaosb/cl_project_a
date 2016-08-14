Rails.application.routes.draw do

	root to: "crawler#welcome"

	scope '/api' do
		scope '/v1' do
			# Crawler
			scope '/crawler' do
				get '/chileautos' => 'crawler#chileautos'
				get '/chileautos/:search' => 'crawler#chileautos'
				get '/chileautos_persistent' => 'crawler#chileautos_persistent'
				get '/chileautos_persistent/:search' => 'crawler#chileautos_persistent'
			end
		end
	end

end
