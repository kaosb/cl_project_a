class CreateCars < ActiveRecord::Migration[5.0]
	def change
		create_table :cars do |t|
			t.integer :site_id
			t.string :imagen
			t.string :link
			t.string :titulo
			t.integer :ano
			t.integer :precio
			t.string :vendedor
			t.string :publicado
			t.integer :visto
			t.string :marca
			t.string :modelo
			t.string :version
			t.string :tipo
			t.string :carroceria
			t.string :color
			t.integer :kilometraje
			t.integer :cilindrada
			t.string :transmision
			t.string :direccion
			t.string :aire
			t.string :radio
			t.string :alzavidrios
			t.string :espejos
			t.string :frenos
			t.string :airbags
			t.string :cierre
			t.string :catalitico
			t.string :combustible
			t.string :traccion
			t.string :llantas
			t.integer :puertas
			t.string :alarma
			t.string :techo
			t.string :patente
			t.timestamps
			t.boolean :status, default: 1
		end
	end
end
