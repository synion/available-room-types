class CreateRoom < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :number
    end
  end
end
