require "action_controller/metal/strong_parameters"

module Widget
  class AvailableRoomForm
     include Virtus.model
     include ActiveModel::Validations

    DATE_FORMAT = /\d{4}-\d{2}-\d{2}/.freeze

    attribute :checkin_date, String, default: nil
    attribute :checkout_date, String, default: nil

    validates :checkin_date,
             :checkout_date,
             format: { with: DATE_FORMAT, message: "wrong date format" },
             if: -> { checkin_present? && checkout_present? }

    validate :checkin_date_and_checkout_date_present
    validate :checkin_date_is_greater_than_checkout_date, if: -> { checkin_present? && checkout_present? }
    validate :checkin_date_is_future, if: -> { checkin_present? && checkout_present? }

    def initialize(*args)
      attributes = args.extract_options!

      if attributes.blank? && args.last.is_a?(ActionController::Parameters)
        attributes = args.pop.to_unsafe_h
      end

      @resource = args.first

      super(build_original_attributes.merge(attributes))
    end

    private
    attr_reader :resource

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

    def checkin_date_and_checkout_date_present
      errors.add(:checkin_date, 'should present') unless checkin_present?
      errors.add(:checkout_date, 'should present') unless checkout_present?
    end

    def build_original_attributes
      return {} if resource.nil?
      base_attributes = resource.respond_to?(:attributes) && resource.attributes.symbolize_keys

      self.class.attribute_set.each_with_object(base_attributes || {}) do |attribute, result|
        if result[attribute.name].blank? && resource.respond_to?(attribute.name)
          result[attribute.name] = resource.public_send(attribute.name)
        end
      end
    end

    def checkin_present?
      checkin_date.to_s != ''
    end

    def checkout_present?
      checkout_date.to_s != ''
    end
  end
end

