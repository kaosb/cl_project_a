class Car < ApplicationRecord

	has_many :car_history_track

	def self.chileautos_persistent_result(result)
		result.each do |obj|
			qresult = Car.where(site_id: obj[:site_id]).first || Car.create(obj)
		end
		return result
	end

	def self.chileautos_crawler(search)
		require 'nokogiri'
		# Declaro los array que almacenaran el resultado.
		result = Array.new
		# Inicializo Mechanize que se encargara de consumir el formulario de busqueda.
		a = TorPrivoxy::Agent.new '127.0.0.1', 'zz359G*wNDHxnT8#GwPmFHs@4', 8118 => 8051
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
					link = 'http:' + (tr.css('td')[1].css('a')[0]['href'] ? tr.css('td')[1].css('a')[0]['href'] : nil)
					site_id = link.gsub('http://www2.chileautos.cl/auto.asp?codauto=','').to_i
					element = {
						site_id: site_id,
						imagen: tr.css('td')[0].css('img')[0]['src'] ? tr.css('td')[0].css('img')[0]['src'] : nil,
						link: link,
						titulo: tr.css('td')[1].css('a')[0].text.squish ? tr.css('td')[1].css('a')[0].text.squish : nil,
						ano: tr.css('td')[2].text.squish.to_i ? tr.css('td')[2].text.squish.to_i : nil,
						precio: tr.css('td')[3].text ? tr.css('td')[3].text.squish.to_s.gsub('$','').gsub('.','').gsub(' ','').to_s.to_i : nil,
						vendedor: tr.css('td')[4].text.squish ? tr.css('td')[4].text.squish : nil
					}
					# Obtengo el detalle de cada row.
					url = 'http:' + tr.css('td')[1].css('a')[0]['href']
					# Agrego el objeto hash al array que los agrupa.
					result << self.chileautos_detail_scraper(url, element)
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
				b = TorPrivoxy::Agent.new '127.0.0.1', 'zz359G*wNDHxnT8#GwPmFHs@4', 8118 => 8051
				document = Nokogiri::HTML(b.get(url).body)
				document.css('.tbl_Principal').css('tr')[1..-1].each do |tr|
					begin
						link = 'http:' + (tr.css('td')[1].css('a')[0]['href'] ? tr.css('td')[1].css('a')[0]['href'] : nil)
						site_id = link.gsub('http://www2.chileautos.cl/auto.asp?codauto=','').to_i
						element = {
							site_id: site_id,
							imagen: tr.css('td')[0].css('img')[0]['src'] ? tr.css('td')[0].css('img')[0]['src'] : nil,
							link: link,
							titulo: tr.css('td')[1].css('a')[0].text.squish ? tr.css('td')[1].css('a')[0].text.squish : nil,
							ano: tr.css('td')[2].text.squish.to_i ? tr.css('td')[2].text.squish.to_i : nil,
							precio: tr.css('td')[3].text ? tr.css('td')[3].text.squish.to_s.gsub('$','').gsub('.','').gsub(' ','').to_s.to_i : nil,
							vendedor: tr.css('td')[4].text.squish ? tr.css('td')[4].text.squish : nil
						}
						# Obtengo el detalle de cada row.
						url = 'http:' + tr.css('td')[1].css('a')[0]['href']
						# Agrego el objeto hash al array que los agrupa.
						result << self.chileautos_detail_scraper(url, element)
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
		return result
	end

	def self.chileautos_detail_scraper(url, element)
		c = TorPrivoxy::Agent.new '127.0.0.1', 'zz359G*wNDHxnT8#GwPmFHs@4', 8118 => 8051
		detail = Nokogiri::HTML(c.get(url).body)
		# Obtengo datos del dom y inicializo el objeto con la informacion preliminar.
		publicado_selector = 'body > div:nth-child(6) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)'
		element[:publicado] = detail.css(publicado_selector)[0] ? detail.css(publicado_selector)[0].text.squish.gsub('Publicado ','').gsub('.','') : nil
		element[:visto] = detail.css('.visitas-auto')[0] ? detail.css('.visitas-auto')[0].text.squish.to_i : nil
		# Obtengo la tabla con detalles, y la recorro buscando los keywords.
		detail.css('table.tablaauto tr').each do |row|
			if row.css('td')[0]
				case row.css('td')[0].text.squish
				when 'Marca:'
					element[:marca] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Modelo:'
					element[:modelo] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Versión:'
					element[:version] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				# when 'Año:'
				# 	element[:ano] = row.css('td')[1] ? row.css('td')[1].text.squish.gsub('_.','').to_i : nil
				when 'Tipo vehíc:'
					element[:tipo] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Carrocería:'
					element[:carroceria] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Color:'
					element[:color] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Kilometraje:'
					element[:kilometraje] = row.css('td')[1] ? row.css('td')[1].text.squish.gsub('.','').to_i : nil
				when 'Cilindrada :'
					element[:cilindrada] = row.css('td')[1] ? row.css('td')[1].text.squish.gsub(' c.c.','').gsub('.','').to_i : nil
				when 'Transmisión:'
					element[:transmision] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Dirección:'
					element[:direccion] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Aire'
					element[:aire] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Radio:'
					element[:radio] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Alzavidrios'
					element[:alzavidrios] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Espejos'
					element[:espejos] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Frenos'
					element[:frenos] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Airbag'
					element[:airbags] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Cierre'
					element[:cierre] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Catalítico'
					element[:catalitico] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Combustible'
					element[:combustible] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when '4WD'
					element[:traccion] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Llantas'
					element[:llantas] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Puertas:'
					element[:puertas] = row.css('td')[1] ? row.css('td')[1].text.squish.to_i : nil
				when 'Alarma'
					element[:alarma] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Techo'
					element[:techo] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				when 'Patente:'
					element[:patente] = row.css('td')[1] ? row.css('td')[1].text.squish : nil
				end
			end
		end
		# Almaceno el registro y/o actualizo el objeto.
		if car = Car.where(site_id: element[:site_id]).first
			if car[:precio] != element[:precio]
				CarHistoryTrack.create({
					car_id: car[:id],
					slug: "precio",
					before: car[:precio],
					after: element[:precio]
					})
			end
			if (car[:visto] != element[:visto]) && (element[:visto] >= car[:visto]+5)
				CarHistoryTrack.create({
					car_id: car[:id],
					slug: "visto",
					before: car[:visto],
					after: element[:visto]
					})
			end
			car.update(element)
		else
			Car.create(element)
		end
		return element
	end

end
