require 'rails_helper'

describe RoomType do
  describe '.grouped_available_room_types' do
    it 'run GroupedAvailableRoomTypesQuery with date range' do
      date_range = Date.parse('2018-09-08')..Date.parse('2018-09-10')
      allow(GroupedAvailableRoomTypesQuery).to receive(:call)

      RoomType.grouped_available_rooms_types(date_range)

      expect(GroupedAvailableRoomTypesQuery).to have_received(:call).with(date_range: date_range)
    end
  end
end
