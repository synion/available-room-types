class CreateReservationsRooms < ActiveRecord::Migration[5.1]
  def change
    create_join_table :rooms, :reservations do |t|
      t.index [:room_id, :reservation_id]
    end
  end
end
