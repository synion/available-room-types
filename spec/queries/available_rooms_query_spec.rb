require 'rails_helper'

describe AvailableRoomsQuery do
  describe '.call' do
    context 'when there are non reservations with given period time' do
      it 'returns all rooms' do
        room_1 = create(:room)
        room_2 = create(:room)

        available_rooms = AvailableRoomsQuery.call(date_range: Date.parse('2018-09-08')..Date.parse('2018-09-10'))

        expect(available_rooms).to eq([room_1, room_2])
      end
    end

    context 'when there are rooms reserved' do
      context 'when in given period time there is room already reserved' do
        it 'returns only free room' do
          free_room = create(:room, reservations: [])
          reserved_room = create(:room, reservations: [build(:reservation,
                                                             checkin_date: Date.parse('2018-09-08'),
                                                             checkout_date: Date.parse('2018-09-10'))])

          available_rooms = AvailableRoomsQuery.call(date_range: Date.parse('2018-09-08')..Date.parse('2018-09-10'))

          expect(available_rooms).to eq([free_room])
        end
      end

      context 'when given period time overlaps with previously reserved rooms' do
        it 'returns room whit not overlapping given period time' do
          free_room_1 = create(:room, reservations: [build(:reservation,
                                                           checkin_date: Date.parse('2018-09-12'),
                                                           checkout_date: Date.parse('2018-09-13'))])
          free_room_2 = create(:room, reservations: [build(:reservation,
                                                           checkin_date: Date.parse('2018-09-03'),
                                                           checkout_date: Date.parse('2018-09-06'))])
          free_room_3 = create(:room, reservations: [build(:reservation,
                                                           checkin_date: Date.parse('2018-09-10'),
                                                           checkout_date: Date.parse('2018-09-12'))])

          reserved_room_1 = create(:room, reservations: [build(:reservation,
                                                               checkin_date: Date.parse('2018-09-03'),
                                                               checkout_date: Date.parse('2018-09-07'))])
          reserved_room_2 = create(:room, reservations: [build(:reservation,
                                                               checkin_date: Date.parse('2018-09-07'),
                                                               checkout_date: Date.parse('2018-09-09'))])
          reserved_room_3 = create(:room, reservations: [build(:reservation,
                                                               checkin_date: Date.parse('2018-09-09'),
                                                               checkout_date: Date.parse('2018-09-11'))])

          available_rooms = AvailableRoomsQuery.call(date_range: Date.parse('2018-09-06')..Date.parse('2018-09-10'))

          expect(available_rooms).to eq([free_room_1, free_room_2, free_room_3])
        end
      end
    end
  end
end
