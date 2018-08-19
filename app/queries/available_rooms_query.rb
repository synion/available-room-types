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
    Room.left_joins(:reservations)
      .where.not('reservations.checkin_date <= ? AND reservations.checkout_date >= ?', date_range.min, date_range.max )
      .where.not('reservations.checkin_date >= ? AND reservations.checkout_date <= ?' , date_range.min, date_range.max)
      .where.not('reservations.checkin_date < ? AND reservations.checkout_date > ?', date_range.max, date_range.max)
      .where.not('reservations.checkin_date < ? AND reservations.checkout_date > ?', date_range.min, date_range.min)
      .or(Room.left_joins(:reservations).where('reservations.id IS NULL'))
  end

  def checkin_date_range
    @date_range
  end
end
