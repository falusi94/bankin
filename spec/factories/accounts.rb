# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:user) { |i| "User ##{i}" }

    bank

    balance { 10_000 }
  end
end
