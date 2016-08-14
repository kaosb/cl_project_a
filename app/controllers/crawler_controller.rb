class CrawlerController < ApplicationController

	def welcome
		render :json => { :status => true, :message => "Project A." }, :status => 200
	end

	def chileautos
		# Verifico Parametros.
		search = params[:search].nil? ? 'cerato' : params[:search].to_s
		result = Car.chileautos_crawler(search)
		if result.any?
			render :json => { :status => true, :message => "Search results.", :result => result }, :status => 200
		else
			render :json => { :status => true, :message => "There was a problem retrieving the information." }, :status => 200
		end
	end

end
