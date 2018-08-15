require 'rails_helper'

describe Api::V1::Widget::AvailableRoomsController do
  describe '#index' do
    it 'returns available room with these attributes' do
      economic = create(:room_type, name: 'Economic', price: 100)
      room = create(:room, number: '100', room_type: economic)
      params = { checkin_date: Date.parse('2018-09-08'), checkout_date: Date.parse('2018-09-10') }

      response_body = {
        room_types: ['Economic'],
        rooms: [
          { number: '100', room_type: 'Economic', total_price: '200 USD' }
        ]
      }

      get :index, params: params, format: :json

      expect(response.body).to eq response_body
    end
  end
end
