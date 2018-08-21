require 'rails_helper'

describe Widget::AvailableRoomForm do
  describe '#valid' do
    it 'requires checkin and checkout date' do
      params = { checkin_date: nil, checkout_date: nil}

      form = Widget::AvailableRoomForm.new(params)

      expect(form.valid?).to be_falsey
      expect(form.errors).to have_key(:checkin_date)
      expect(form.errors).to have_key(:checkin_date)
    end

    it 'requires checkin and checkout to be in format iso 8601' do
      params = { checkin_date: '20-09-2019', checkout_date: '2019-09-22'}

      form = Widget::AvailableRoomForm.new(params)

      expect(form.valid?).to be_falsey
      expect(form.errors).to have_key(:checkin_date)
    end

    it 'requires checkin date to be greater than checkout date' do
      params = { checkin_date: '2019-09-26', checkout_date: '2019-09-22'}

      form = Widget::AvailableRoomForm.new(params)

      expect(form.valid?).to be_falsey
      expect(form.errors).to have_key(:checkin_date)
    end

    it 'requires  checkin date to be in future' do
      travel_to DateTime.new(2001, 9, 1) do
        params = { checkin_date: Date.new(2000, 9, 1).to_s, checkout_date: Date.new(2000, 9, 10)}

        form = Widget::AvailableRoomForm.new(params)

        expect(form.valid?).to be_falsey
        expect(form.errors).to have_key(:checkin_date)
      end
    end
  end
end
