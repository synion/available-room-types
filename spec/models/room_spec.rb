require 'rails_helper'

describe Room do
  describe '.available_rooms' do
    it 'run AvailableRoomsQuery with date range' do
      date_range = Date.parse('2018-09-08')..Date.parse('2018-09-10')
      allow(AvailableRoomsQuery).to receive(:call)

      Room.available_rooms(date_range)

      expect(AvailableRoomsQuery).to have_received(:call).with(date_range: date_range)
    end
  end
end
