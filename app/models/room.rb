class Room < ApplicationRecord
  belongs_to :room_type
  has_and_belongs_to_many :reservations

  scope :available_rooms, ->(date_range) { AvailableRoomsQuery.call(date_range: date_range) }
end
