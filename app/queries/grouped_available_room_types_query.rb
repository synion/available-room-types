class GroupedAvailableRoomTypesQuery
  NUMBER_AVAILABLE_ROOM = 'count_room_ids'.freeze
  TOTAL_PRICE = 'total_price'.freeze

  def self.call(date_range:)
    new(date_range: date_range).call
  end

  def initialize(date_range:)
    @date_range = date_range
  end

  def call
    all_available_rooms_types
  end

  private
  attr_reader :date_range

  def defined_selector
    <<-SQL.squish
      room_types.name, room_types.id, room_types.price,
      COUNT(rooms.id) AS #{ NUMBER_AVAILABLE_ROOM },
      room_types.price * #{date_range.count} AS #{TOTAL_PRICE}
    SQL
  end

  def all_available_rooms_types
    available_rooms_ids = Room.available_rooms(date_range).pluck(:id)
    RoomType.joins(:rooms)
             .where(rooms: { id: available_rooms_ids })
             .select(defined_selector)
             .group(:name, :price, :id)
  end
end
