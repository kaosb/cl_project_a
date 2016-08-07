Rails.application.routes.draw do

	root to: "crawler#welcome"

	scope '/api' do
		scope '/v1' do
			# Crawler
			scope '/crawler' do
				get '/chileautos' => 'crawler#chileautos'
				get '/chileautos/:search' => 'crawler#chileautos'
			end
		end
	end

end
