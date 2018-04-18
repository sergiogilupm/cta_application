class Add24HToLine < ActiveRecord::Migration[5.1]
  def change
    add_column :lines, :_24H_service, :boolean
  end
end
