class UpdateStation < ActiveRecord::Migration[5.1]
  def change
    add_column :stations, :map_id, :integer
    add_column :stations, :latitude, :integer
    add_column :stations, :longitude, :integer
    remove_column :stations, :cta_identifier, :integer
  end
end
