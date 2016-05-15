# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    sequence(:content) { |n| "Comment #{n}" }
  end
end
