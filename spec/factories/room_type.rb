FactoryBot.define do
  factory :room_type do
    trait :from_grouped_available_room_types do
      transient do
        total_price { 500.00 }
        count_room_ids { 2 }
      end

      after(:create) do |room_type, evaluator|
        room_type.define_singleton_method(:total_price) { evaluator.total_price }
      end

      after(:create) do |room_type, evaluator|
        room_type.define_singleton_method(:count_room_ids) { evaluator.count_room_ids }
      end
    end
  end
end
