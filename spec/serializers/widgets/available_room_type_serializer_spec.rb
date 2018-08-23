require 'rails_helper'

describe Widgets::AvailableRoomTypeSerializer do
  describe '.serialized_json' do
    context 'when serialize collection of room types' do
      context 'when options links and meta are empty' do
        it 'returns json with presented attributes and links' do
          economic = create(:room_type,
                     :from_grouped_available_room_types,
                     total_price: 300.00,
                     count_room_ids: 5,
                     name: 'Economic')

          president = create(:room_type,
                     :from_grouped_available_room_types,
                     total_price: 500.00,
                     count_room_ids: 1,
                     name: 'president')

          options = {}
          serialized_room_type = Widgets::AvailableRoomTypeSerializer.new([economic, president], options).serialized_json
          expect(JSON.parse(serialized_room_type)).to eql(
             {
              "data" => [
                {
                  "attributes" => {
                    "name" => "Economic",
                    "number_available_rooms" => '5',
                    "total_price" => '300.0'
                  },
                  "id" => economic.id.to_s, "type" => "room_type"
                },
                {
                  "attributes" => {
                    "name" => "president",
                    "number_available_rooms" => '1',
                    "total_price" => '500.0'
                  },
                "id" => president.id.to_s, "type" => "room_type"
                }
              ]
            }
          )
        end
      end

      context 'when options include links and meta' do
        it 'includes links and meta json  and links' do
          room_collection = create_list(:room_type, 6, :from_grouped_available_room_types)
          options = {
                      meta: { total_pages: 2 },
                      links: {
                        'self': 'http::/available_room.com/api/v1/widget/available_rooms?page=1',
                        'next': 'http::/available_room.com/api/v1/widget/available_rooms?page=2',
                        'prev': ''
                      }
                    }
          serialized_room_type = Widgets::AvailableRoomTypeSerializer.new(room_collection, options).serialized_json

          expect(JSON.parse(serialized_room_type)).to include("links"=>
            {
              "self" => "http::/available_room.com/api/v1/widget/available_rooms?page=1",
              "next" => "http::/available_room.com/api/v1/widget/available_rooms?page=2",
              "prev" => ""
            },
            'meta' => { 'total_pages' => 2 }
          )
        end
      end
    end
  end
end
