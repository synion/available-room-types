require 'rails_helper'

describe Api::V1::Widget::AvailableRoomsController do
  describe '#index' do
    context 'when available room query returns rooms' do
      it 'returns available room with these attributes' do
        economic = create(:room_type, name: 'Economic', price: 100)
        room = create(:room, number: '100', room_type: economic)
        params = { checkin_date: '2018-09-08', checkout_date: '2018-09-10' }

        allow(Room).to receive(:available_rooms).with('2018-09-08'..'2018-09-10').and_call_original

        get :index, params: params, format: :json

        response_body = {
          room_types: ['Economic'],
          rooms: [{ count_available_rooms: 1, type: 'Economic', total_price: '300 USD' }]
        }

        expect(response.body).to eq response_body.to_json
      end
    end
  end
end
