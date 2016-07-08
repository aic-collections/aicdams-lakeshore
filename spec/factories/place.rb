# frozen_string_literal: true
FactoryGirl.define do
  factory :place do
    pref_label "Sample Place"

    trait :with_sample_metadata do
      lat "41.881832"
      long "-87.623177"
    end
  end
end
