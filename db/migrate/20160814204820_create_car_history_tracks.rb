class CreateCarHistoryTracks < ActiveRecord::Migration[5.0]
	def change
		create_table :car_history_tracks do |t|
			t.integer :car_id, :null => false, :references => [:cars, :id]
			t.string :slug
			t.string :before
			t.string :after
			t.timestamps
			t.boolean :status, default: 1
		end
	end
end
