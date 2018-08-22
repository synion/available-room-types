require 'rails_helper'

describe GroupedAvailableRoomTypesQuery do
  describe '.call' do
    context 'when available room ids retuns collection of not reserved rooms' do
      it 'returns collection of room types with new methods' do
        date_range = Date.parse('2018-09-08')..Date.parse('2018-09-10')
        economic = create(:room_type, name: 'Economic', price: 100.00)
        president = create(:room_type, name: 'President', price: 500.00)
        room_1 = create(:room, room_type: economic)
        room_2 = create(:room, room_type: economic)
        room_3 = create(:room, room_type: president)
        room_4 = create(:room, room_type: president)

        not_available_room_type = create(:room_type, name: 'Not available rooms type', price: 200.00)
        create(:room, room_type: not_available_room_type)

        rooms = double(Room)
        allow(Room).to receive(:available_rooms)
          .with(Date.parse('2018-09-08')..Date.parse('2018-09-10')) { rooms }
        allow(rooms).to receive(:pluck).with(:id) { [room_1.id, room_2.id, room_3.id] }

        available_room_types = GroupedAvailableRoomTypesQuery.call(date_range: date_range)

        economic_with_new_methods = available_room_types.first
        president_with_new_methods = available_room_types.second

        expect(available_room_types).to match_array([economic, president])

        expect(economic_with_new_methods.total_price).to eq 300.00
        expect(economic_with_new_methods.count_room_ids).to eq 2

        expect(president_with_new_methods.total_price).to eq 1500.00
        expect(president_with_new_methods.count_room_ids).to eq 1
      end
    end

    context 'when available room ids is empty' do
      it 'returns empty collection' do
        date_range = Date.parse('2018-09-08')..Date.parse('2018-09-10')
        rooms = double(Room)
        allow(Room).to receive(:available_rooms)
          .with(Date.parse('2018-09-08')..Date.parse('2018-09-10')) {[]}

        available_room_types = GroupedAvailableRoomTypesQuery.call(date_range: date_range)

        expect(available_room_types).to eq []
      end
    end
  end
end
