module Widgets
  class AvailableRoomTypeSerializer
    include FastJsonapi::ObjectSerializer

    set_type :room_type

    attributes :name
    attributes :total_price do |room_type|
      room_type.total_price.to_s
    end

    attributes :number_available_rooms do |room_type|
      room_type.count_room_ids.to_s
    end
  end
end
