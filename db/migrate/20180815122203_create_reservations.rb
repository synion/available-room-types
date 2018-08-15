class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.date :checkin_date
      t.date :checkout_date

      t.timestamps
    end
  end
end
