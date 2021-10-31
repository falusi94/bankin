# frozen_string_literal: true

FactoryBot.define do
  factory :bank do
    initialize_with { new(attributes) }

    sequence(:name) { |i| "Bank ##{i}" }
  end
end
