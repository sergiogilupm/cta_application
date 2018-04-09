class CreateLines < ActiveRecord::Migration[5.1]
  def change
    drop_table :lines
    create_table :lines do |t|
      t.string :internal_name
      t.string :name

      t.timestamps
    end
  end
end
