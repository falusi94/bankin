# frozen_string_literal: true

FactoryBot.define do
  factory :transfer do
    initialize_with { new(attributes) }

    amount { 100 }

    trait :inter_bank do
      origin      { build(:account) }
      destination { build(:account) }
    end

    trait :intra_bank do
      origin      { build(:account) }
      destination { build(:account, bank: origin.bank) }
    end

    trait :successful do
      after :build do |transfer|
        transfer.instance_variable_set(:@completed_at, Time.now)
      end
    end
  end

  factory :intra_bank_transfer, parent: :transfer, traits: [:intra_bank]
  factory :inter_bank_transfer, parent: :transfer, traits: [:inter_bank] do
    trait :over_limit do
      amount { Transfer::INTERBANK_AMOUNT_LIMIT + 5 }
    end
  end
end
