class CrawlerController < ApplicationController

	def welcome
		render :json => { :status => true, :message => "Project A." }, :status => 200
	end

	def switch_endpoint
		require 'net/telnet'
		localhost = Net::Telnet::new("Host" => "127.0.0.1", "Port" => "8051", "Timeout" => 10, "Prompt" => /250 OK\n/)
		localhost.cmd('AUTHENTICATE "zz359G*wNDHxnT8#GwPmFHs@4"') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
		localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
		localhost.close
	end

	def chileautos
		require 'mechanize'
		require 'nokogiri'
		require 'open-uri'
		# Verifico Parametros.
		search = params[:search].nil? ? 'cerato' : params[:search].to_s
		# Declaro los array que almacenaran el resultado.
		result = Array.new
		# Inicializo Mechanize que se encargara de consumir el formulario de busqueda.
		a = Mechanize.new
		a.set_proxy('127.0.0.1', 8118)
		# a = TorPrivoxy::Agent.new '127.0.0.1', 'zz359G*wNDHxnT8#GwPmFHs@4', 8118 => 8051
		a.get('http://www2.chileautos.cl/chileautos.asp') do |page|
			# Seteo el formulario y lo ejecuto.
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
			# Obtenemos el DOM, y lo parceamos.
			body = Nokogiri::HTML(search_result.body)
			# Obtenemos la tabla de resultados y la iteramos.
			body.css('.tbl_Principal').css('tr')[1..-1].each do |tr|
				begin
					# Proceso el resultado por row.
					image = tr.css('td')[0].css('img')[0]['src'] ? tr.css('td')[0].css('img')[0]['src'] : nil
					link = 'http:' + (tr.css('td')[1].css('a')[0]['href'] ? tr.css('td')[1].css('a')[0]['href'] : nil)
					brand_model = tr.css('td')[1].css('a')[0].text.squish ? tr.css('td')[1].css('a')[0].text.squish : nil
					year = tr.css('td')[2].text.squish.to_i ? tr.css('td')[2].text.squish.to_i : nil
					price = tr.css('td')[3].text ? tr.css('td')[3].text.squish.to_s.gsub('$','').gsub('.','').gsub(' ','').to_s.to_i : nil
					seller = tr.css('td')[4].text.squish ? tr.css('td')[4].text.squish : nil
					# Obtengo el detalle de cada row.
					detail = Nokogiri::HTML(open('http:' + tr.css('td')[1].css('a')[0]['href'], :proxy => "http://127.0.0.1:8118"))
					xpath = 'body > div:nth-child(6) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)'
					published = detail.css(xpath)[0] ? detail.css(xpath)[0].text.squish.gsub('Publicado ','').gsub('.','') : nil
					viewed = detail.css('.visitas-auto')[0] ? detail.css('.visitas-auto')[0].text.squish.to_i : nil
					element = {
						image: image,
						link: link,
						brand_model: brand_model,
						year: year,
						price: price,
						seller: seller,
						published: published,
						viewed: viewed
					}
					result << element
				rescue StandardError => e
					puts "Parse error #{e.message}"
					puts " - - - -"
					puts e.inspect
					puts " - - - -"
					puts tr.inspect
				end
			end
			## Reviso las otras paginas
			body.css('.nav').each do |link|
				url = 'http:' + link['href']
				document = Nokogiri::HTML(open(url, :proxy => "http://127.0.0.1:8118"))
				document.css('.tbl_Principal').css('tr')[1..-1].each do |tr|
					begin
						# Proceso el resultado por row.
						image = tr.css('td')[0].css('img')[0]['src'] ? tr.css('td')[0].css('img')[0]['src'] : nil
						link = 'http:' + (tr.css('td')[1].css('a')[0]['href'] ? tr.css('td')[1].css('a')[0]['href'] : nil)
						brand_model = tr.css('td')[1].css('a')[0].text.squish ? tr.css('td')[1].css('a')[0].text.squish : nil
						year = tr.css('td')[2].text.squish.to_i ? tr.css('td')[2].text.squish.to_i : nil
						price = tr.css('td')[3].text ? tr.css('td')[3].text.squish.to_s.gsub('$','').gsub('.','').gsub(' ','').to_s.to_i : nil
						seller = tr.css('td')[4].text.squish ? tr.css('td')[4].text.squish : nil
						# Obtengo el detalle de cada row.
						detail = Nokogiri::HTML(open('http:' + tr.css('td')[1].css('a')[0]['href'], :proxy => "http://127.0.0.1:8118"))
						xpath = 'body > div:nth-child(6) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)'
						published = detail.css(xpath)[0] ? detail.css(xpath)[0].text.squish.gsub('Publicado ','').gsub('.','') : nil
						viewed = detail.css('.visitas-auto')[0] ? detail.css('.visitas-auto')[0].text.squish.to_i : nil
						element = {
							image: image,
							link: link,
							brand_model: brand_model,
							year: year,
							price: price,
							seller: seller,
							published: published,
							viewed: viewed
						}
						result << element
					rescue StandardError => e
						puts "Parse error #{e.message}"
						puts " - - - -"
						puts e.inspect
						puts " - - - -"
						puts tr.inspect
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

	def proxychileautos
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
		a.set_proxy('127.0.0.1', 8118)
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
		end
		body = Nokogiri::HTML(search_result.body)
		if body.any?
			render :json => { :status => true, :message => "Results.", :body => body }, :status => 200
		else
			render :json => { :status => true, :message => "There was a problem retrieving the information." }, :status => 200
		end
	end
end
