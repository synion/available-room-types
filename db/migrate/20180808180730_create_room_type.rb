class CreateRoomType < ActiveRecord::Migration[5.1]
  def change
    create_table :room_types do |t|
      t.string :name
      t.float :price
    end
  end
end
