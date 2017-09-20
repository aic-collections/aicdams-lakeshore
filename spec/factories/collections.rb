# frozen_string_literal: true
FactoryGirl.define do
  factory :private_collection, class: Collection do
    transient do
      user { FactoryGirl.create(:user1) }
    end

    sequence(:title) { |n| ["Title #{n}"] }

    after(:build) do |asset, evaluator|
      asset.apply_depositor_metadata(evaluator.user)
    end

    factory :public_collection do
      after(:build) do |collection|
        collection.send(:public_visibility!)
        collection.send(:publishable!)
      end
    end

    factory :registered_collection do
      after(:build) do |collection|
        collection.send(:registered_visibility!)
        collection.send(:unpublishable!)
      end
    end

    factory :department_collection, aliases: [:collection] do
      after(:build) do |collection|
        collection.send(:department_visibility!)
        collection.send(:unpublishable!)
      end
    end

    factory :named_collection do
      title ['collection title']
      description ['collection description']
    end

    trait :with_metadata do
      title                 ["Collection with metadata"]
      publish_channel_uris  ["http://definitions.artic.edu/publish_channel/Web"]
      collection_type_uri   { create(:list_item, pref_label: "collection type").uri }
    end
  end
end
