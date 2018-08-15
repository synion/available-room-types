class AvailableRoomsQuery
  def self.call(date_range:)
    new(date_range: date_range).call
  end

  def initialize(date_range:)
    @date_range = date_range
  end

  def call
    all_available_rooms
  end

  private

  attr_reader :date_range

  def room
    @room ||= Room
  end

  def all_available_rooms
    reserved_room_ids = reserved_rooms.pluck(:id)
    room.where.not(id: reserved_room_ids)
  end

  def reserved_rooms
    reserved_rooms ||= room.left_joins(:reservations)
                           .where(reservations: { checkin_date: date_range })
                           .where.not(reservations: { checkin_date: date_range.max})
                           .or(room.left_joins(:reservations).where(reservations: { checkout_date: date_range})
                                   .where.not(reservations: { checkout_date: date_range.min}))
  end

  def checkin_date_range
    @date_range
  end
end
