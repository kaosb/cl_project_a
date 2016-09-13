class CarController < ApplicationController

	def index
		# cars = Car.where(status: 1)
		cars = Car.all
		if cars.any?
			render :json => { :status => true, :message => "All vehicles in the system.", :cars => cars }, :status => 200
		else
			render :json => { :status => true, :message => "No vehicles were found in the system." }, :status => 200
		end
	end

	def show
		car = Car.where(id: params[:car_id])
		if car = Car.where(id: params[:car_id]).first
			view_variation = CarHistoryTrack.where(car_id: car[:id], slug: 'visto')
			price_variation = CarHistoryTrack.where(car_id: car[:id], slug: 'precio')
			render :json => { :status => true, :car => car, :view_variation => view_variation, :price_variation => price_variation }, :status => 200
		else
			render :json => { :status => false, :message => "The car does not exist." }, :status => 200
		end
	end

	def search
		# Verifico Parametros.
		search = params[:search].nil? ? nil : params[:search].to_s
		from = params[:from].nil? ? nil : params[:from].to_s
		to = params[:to].nil? ? nil : params[:to].to_s
		if search && from && to
			result = Car.where("titulo LIKE ? AND created_at >= ? AND created_at <= ?", "%#{search}%", from, to)
		elsif search && from
			result = Car.where("titulo LIKE ? AND created_at >= ? ", "%#{search}%", from)
		elsif search
			result = Car.where("titulo LIKE ?", "%#{search}%")
		else
			render :json => { :status => true, :message => "insufficient parameters." }, :status => 200
		end
		# Verifico la existencia de resultados, y el retorno respectivo.
		if result.any?
			render :json => { :status => true, :message => "Search results.", :result => result }, :status => 200
		else
			render :json => { :status => true, :message => "No results for #{search}." }, :status => 200
		end
	end

end
