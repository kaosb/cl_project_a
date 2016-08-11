class CrawlerController < ApplicationController

	def welcome
		render :json => { :status => true, :message => "Project A." }, :status => 200
	end

	def chileautos
		require 'mechanize'
		require 'nokogiri'
		require 'open-uri'
		if params[:search].nil?
			search = "cerato"
		else
			search = params[:search].to_s
		end
		result = Array.new
		error_obj = Array.new
		a = Mechanize.new
		# a.set_proxy('127.0.0.1', '8050')
		a.get('http://www2.chileautos.cl/chileautos.asp') do |page|
			search_result = page.form_with(:name => 'form_vehiculos') do |form|
				model_field = form.field_with(:name => 'modelo')
				model_field.value = search
				ai_field = form.field_with(:name => 'ai')
				ai_field.value = 2012
				af_field = form.field_with(:name => 'af')
				af_field.value = 2016
				dea_field = form.field_with(:name => 'dea')
				dea_field.value = 100
				button = form.button
			end.submit
			# Parseo y muestro
			body = Nokogiri::HTML(search_result.body)
			body.css('.tbl_Principal').css('tr').each do |tr|
				begin
					url = 'http:' + tr.css('td')[1].css('a')[0]['href']
					detail = Nokogiri::HTML(open(url, :proxy => "http://127.0.0.1:8050"))
					published = detail.css('body > div:nth-child(6) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)')[0].text.squish
					viewed = detail.css('.visitas-auto')[0].text.squish
					element = {
						image: tr.css('td')[0].css('img')[0]['src'],
						link: 'http:' + tr.css('td')[1].css('a')[0]['href'],
						brand_model: tr.css('td')[1].css('a')[0].text.squish,
						year: tr.css('td')[2].text.squish.to_i,
						price: tr.css('td')[3].text.squish.gsub('$','').gsub('.','').gsub(' ','').to_i,
						seller: tr.css('td')[4].text.squish,
						published: published.gsub('Publicado ',''),
						viewed: viewed.to_i
					}
					result << element
				rescue StandardError => e
					# error_obj << tr
					puts "Parse error #{e.message}"
				end
			end
			## Reviso las otras paginas
			body.css('.nav').each do |link|
				document = Nokogiri::HTML(open('http:'+link['href'], :proxy => "http://127.0.0.1:8050"))
				document.css('.tbl_Principal').css('tr').each do |tr|
					begin
						url = 'http:' + tr.css('td')[1].css('a')[0]['href']
						detail = Nokogiri::HTML(open(url, :proxy => "http://127.0.0.1:8050"))
						# detail = Nokogiri::HTML(open(url, :proxy => "http://127.0.0.1:8050"))
						published = detail.css('body > div:nth-child(6) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)')[0].text.squish
						viewed = detail.css('.visitas-auto')[0].text.squish
						element = {
							image: tr.css('td')[0].css('img')[0]['src'],
							link: 'http:' + tr.css('td')[1].css('a')[0]['href'],
							brand_model: tr.css('td')[1].css('a')[0].text.squish,
							year: tr.css('td')[2].text.squish.to_i,
							price: tr.css('td')[3].text.squish.gsub('$','').gsub('.','').gsub(' ','').to_i,
							seller: tr.css('td')[4].text.squish,
							published: published.gsub('Publicado ',''),
							viewed: viewed.to_i
						}
						result << element
					rescue StandardError => e
						# error_obj << tr
						puts "Parse error #{e.message}"
					end
				end
			end
		end
		if result.any?
			render :json => { :status => true, :message => "Search Results.", :result => result }, :status => 200
		else
			render :json => { :status => true, :message => "There was a problem retrieving the information." }, :status => 200
		end
	end
end
