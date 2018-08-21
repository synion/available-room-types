module Widget
  class AvailableRoomForm
     include Virtus.model
     include ActiveModel::Validations

     DATE_FORMAT = /\d{4}-\d{2}-\d{2}/.freeze

     attribute :checkin_date, String
     attribute :checkout_date, String

     validates :checkin_date, :checkin_date, presence: true
     validates :checkin_date,
               :checkout_date,
               format: { with: DATE_FORMAT, message: "wrong date format" },
               if: -> { checkin_date && checkout_date}

     validate :checkin_date_is_greater_than_checkout_date, if: -> { checkin_date && checkout_date}

     validate :checkin_date_is_future, if: -> { checkin_date && checkout_date}

     private

     def checkin_date_is_greater_than_checkout_date
       if Date.parse(checkout_date) <= Date.parse(checkin_date)
         errors.add(:checkin_date, 'should be greate than checkout date')
       end
     end

     def checkin_date_is_future
       if Date.parse(checkin_date) <= Date.current
         errors.add(:checkin_date, 'should be in future')
       end
     end
  end
end

