# frozen_string_literal: true

FactoryBot.define do
  factory :bank do
    sequence(:name) { |i| "Bank ##{i}" }
  end
end
