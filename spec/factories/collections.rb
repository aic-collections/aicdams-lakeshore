# frozen_string_literal: true
FactoryGirl.define do
  factory :collection do
    transient do
      user { FactoryGirl.create(:user1) }
    end

    sequence(:title) { |n| ["Title #{n}"] }

    after(:build) do |asset, evaluator|
      asset.apply_depositor_metadata(evaluator.user)
    end

    factory :public_collection do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :registered_collection do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end

    factory :department_collection do
      visibility Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    end

    factory :named_collection do
      title ['collection title']
      description ['collection description']
    end

    trait :with_metadata do
      title                 ["Collection with metadata"]
      publish_channel_uris  ["http://definitions.artic.edu/publish_channel/Web"]
    end
  end
end
