class CreateStationDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :station_details do |t|
      t.integer :map_id
      t.string :internal_line_name

      t.timestamps
    end
  end
end
