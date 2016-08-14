class CreateCars < ActiveRecord::Migration[5.0]
	def change
		create_table :cars do |t|
			t.integer :site_id, null: false
			t.string :imagen, null: true
			t.string :link, null: true
			t.string :titulo, null: true
			t.integer :ano, null: true
			t.integer :precio, null: true
			t.string :vendedor, null: true
			t.string :publicado, null: true
			t.integer :visto, null: true
			t.string :marca, null: true
			t.string :modelo, null: true
			t.string :version, null: true
			t.string :tipo, null: true
			t.string :carroceria, null: true
			t.string :color, null: true
			t.integer :kilometraje, null: true
			t.string :aire, null: true
			t.string :radio, null: true
			t.string :alzavidrios, null: true
			t.string :espejos, null: true
			t.string :frenos, null: true
			t.string :airbags, null: true
			t.string :cierre, null: true
			t.string :catalitico, null: true
			t.string :combustible, null: true
			t.string :llantas, null: true
			t.integer :puertas, null: true
			t.string :alarma, null: true
			t.string :patente, null: true
			t.timestamps
			t.boolean :status, default: 1, null: true
		end
	end
end
