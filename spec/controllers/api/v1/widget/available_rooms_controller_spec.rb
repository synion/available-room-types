require 'rails_helper'

describe Api::V1::Widget::AvailableRoomsController do
  describe '#index' do
    context 'when found user with given token' do
      context 'when page present' do
        context 'when checkin_date present' do
          context 'when checkout_date present' do
            context 'when there are available rooms types' do
              it 'returns only 5 room from given page with present attributes' do
                user = create(:user, token: 'A23BCD')
                room_type_1 = create(:room_type, name: 'Double', rooms: build_list(:room, 4), price: 150.00)
                room_type_2 = create(:room_type, name: 'Single', rooms: build_list(:room, 4), price: 100.00)
                room_type_3 = create(:room_type, name: 'Triple', rooms: build_list(:room, 4), price: 250.00)
                room_type_4 = create(:room_type, name: 'Queen', rooms: build_list(:room, 15), price: 350.00)
                room_type_5 = create(:room_type, name: 'King', rooms: build_list(:room, 15), price: 330.00)
                room_type_6 = create(:room_type, name: 'Economic', rooms: build_list(:room, 10), price: 200.00)
                room_type_7 = create(:room_type, name: 'President', rooms: build_list(:room, 5), price: 500.00)
                room_type_8 = create(:room_type, name: 'Twin', rooms: build_list(:room, 15), price: 300.00)
                room_type_9 = create(:room_type, name: 'Double Double', rooms: build_list(:room, 15), price: 400.00)
                room_type_10 = create(:room_type, name: 'Studio', rooms: build_list(:room, 15), price: 600.00)
                room_type_11 = create(:room_type, name: 'Super Studio', rooms: build_list(:room, 15), price: 1000.00)

                params = { page: 2 , checkin_date: '2019-09-19', checkout_date: '2019-09-22' }

                request.headers['API_TOKEN'] = user.token
                get :index, params: params, format: :json

                expect(JSON.parse(response.body)).to eq('data' =>
                  [
                    {
                      'id' => room_type_6.id.to_s,
                      'type' => 'room_type',
                      'attributes' => { 'name' => 'Economic',
                                       'total_price' =>"800.0",
                                       'number_available_rooms' => '10' },
                    },
                    {
                      'id' => room_type_7.id.to_s,
                      'type' => 'room_type',
                      'attributes' => { 'name' => 'President',
                                       'total_price' => '2000.0',
                                       'number_available_rooms' => '5' }
                    },
                    {
                      'id' => room_type_8.id.to_s,
                      'type' => 'room_type',
                      'attributes' => { 'name' => 'Twin', 'total_price' => '1200.0', 'number_available_rooms' => '15' }
                    },
                    {
                      'id' => room_type_9.id.to_s,
                      'type' => 'room_type',
                      'attributes' => { 'name' => 'Double Double', 'total_price' => '1600.0',
                                      'number_available_rooms' => '15' }
                    },
                    {
                      'id' => room_type_10.id.to_s,
                      'type' => 'room_type',
                      'attributes' => { 'name' => 'Studio',
                                        'total_price' => '2400.0',
                                        'number_available_rooms' => '15' }
                    }
                  ],
                  'meta' =>
                    {
                      'room_types' =>
                      ['Double', 'Double Double', 'Economic', 'King', 'President',
                       'Queen', 'Single', 'Studio', 'Super Studio', 'Triple', 'Twin']
                    },
                  'links' =>
                    {
                     'self' => 'localhost/api/v1/widget/available_rooms'\
                             '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=2',
                     'first' => 'localhost/api/v1/widget/available_rooms'\
                              '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=1',
                     'last' => 'localhost/api/v1/widget/available_rooms'\
                             '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=3',
                     'next' => 'localhost/api/v1/widget/available_rooms'\
                             '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=3',
                     'prev' => 'localhost/api/v1/widget/available_rooms'\
                             '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=1'
                   }
                )
              end
            end

            context "when there isn't any available rooms types" do
              it 'returns none available rooms' do
                user = create(:user, token: 'A23BCD')

                params = { page: 2 , checkin_date: '2019-09-19', checkout_date: '2019-09-22' }

                request.headers['API_TOKEN'] = user.token
                get :index, params: params, format: :json

                expect(JSON.parse(response.body)).to eq({ 'data' => [], 'meta' => { 'room_types' => [] } })
                expect(response).to have_http_status(200)
              end
            end
          end

          context 'when checkout_date not present' do
            it 'returns error with message' do
              user = create(:user, token: 'A23BCD')

              params = { page: 2 , checkin_date: '2019-09-19' }

              request.headers['API_TOKEN'] = user.token
              get :index, params: params, format: :json

              expect(JSON.parse(response.body)).to eq('checkout_date' => ['should present'])
              expect(response).to have_http_status(400)
            end
          end
        end

        context 'when checkin_date not present' do
          it 'returns error with message' do
            user = create(:user, token: 'A23BCD')

            params = { page: 2 , checkout_date: '2019-09-19' }

            request.headers['API_TOKEN'] = user.token
            get :index, params: params, format: :json

            expect(JSON.parse(response.body)).to eq('checkin_date' => ['should present'])
            expect(response).to have_http_status(400)
          end
        end
      end

      context "when page isn't present" do
        it 'returns first 5 available_rooms' do
          user = create(:user, token: 'A23BCD')
          room_type_1 = create(:room_type, name: 'Double', rooms: build_list(:room, 4), price: 150.00)
          room_type_2 = create(:room_type, name: 'Single', rooms: build_list(:room, 4), price: 100.00)
          room_type_3 = create(:room_type, name: 'Triple', rooms: build_list(:room, 4), price: 250.00)
          room_type_4 = create(:room_type, name: 'Queen', rooms: build_list(:room, 15), price: 350.00)
          room_type_5 = create(:room_type, name: 'King', rooms: build_list(:room, 15), price: 330.00)
          room_type_6 = create(:room_type, name: 'Economic', rooms: build_list(:room, 10), price: 200.00)
          params = { checkin_date: '2019-09-19', checkout_date: '2019-09-22' }

          request.headers['API_TOKEN'] = user.token
          get :index, params: params, format: :json

          expect(JSON.parse(response.body)).to eq('data' =>
            [
              {
                'id' => room_type_1.id.to_s,
                'type' => 'room_type',
                'attributes' => { 'name' => 'Double', 'number_available_rooms' => '4', 'total_price' => '600.0' }
              },
              {
                'id' => room_type_2.id.to_s,
                'type' => 'room_type',
                'attributes' => { "name"=>'Single', 'number_available_rooms' => '4', 'total_price' => '400.0' }
              },
              {
                'id' => room_type_3.id.to_s,
                'type' => 'room_type',
                'attributes' => { 'name' =>"Triple", 'number_available_rooms' => '4', 'total_price' => '1000.0' }
              },
              {
                'id' => room_type_4.id.to_s,
                'type' => 'room_type',
                'attributes' => { 'name' => 'Queen', 'number_available_rooms' => '15', 'total_price' => '1400.0' }
              },
              {
                'id' => room_type_5.id.to_s,
                'type' => 'room_type',
                'attributes' => { 'name' => 'King', 'number_available_rooms' => '15', 'total_price' => '1320.0' }
              }
            ],
            'meta' => { 'room_types' => ['Double', 'Economic', 'King', 'Queen', 'Single', 'Triple'] },
            'links' => {
               'self' => 'localhost/api/v1/widget/available_rooms'\
                       '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=1',
               'first' => 'localhost/api/v1/widget/available_rooms'\
                        '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=1',
               'last' => 'localhost/api/v1/widget/available_rooms'\
                       '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=2',
               'next' => 'localhost/api/v1/widget/available_rooms'\
                       '?checkin_date=2019-09-19&checkout_date=2019-09-22&page=2'
              }
          )
        end
      end
    end

    context 'when user with given token not found' do
      it 'returns unauthorize' do
        user = create(:user, token: 'ASDCAD')

        params = { page: 2 , checkout_date: '2019-09-19', checkout_date: '2019-09-21' }

        request.headers['API_TOKEN'] = 'ASD343ASC23'
        get :index, params: params, format: :json

        expect(response.body).to eq('Not Authorized')
        expect(response).to have_http_status(401)
      end
    end
  end
end
