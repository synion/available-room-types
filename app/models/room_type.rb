class RoomType < ApplicationRecord
  has_many :rooms
  scope :grouped_available_rooms_types, ->(date_range) { GroupedAvailableRoomTypesQuery.call(date_range: date_range) }
end
