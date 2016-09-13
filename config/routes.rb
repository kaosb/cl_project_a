Rails.application.routes.draw do

	devise_for :users
	# root to: "crawler#welcome"
	root to: "reports#index"

	get 'reports/index'
	get 'reports/dashboard'

	# API
	scope '/api' do
		scope '/v1' do
			# Crawler
			scope '/crawler' do
				get '/chileautos' => 'crawler#chileautos'
				get '/chileautos/:search' => 'crawler#chileautos'
			end
			scope '/car' do
				get '/' => 'car#index'
				get '/:car_id' => 'car#show'
				get	'/search/:search' => 'car#search'
			end
		end
	end

end
