# frozen_string_literal: true
FactoryGirl.define do
  factory :generic_work, aliases: [:asset_without_type] do
    transient do
      user { FactoryGirl.create(:user1) }
    end

    after(:build) do |asset, evaluator|
      asset.apply_depositor_metadata(evaluator.user)
    end

    factory :still_image_asset, aliases: [:asset] do
      after(:build, &:assert_still_image)

      factory :department_asset do
        visibility Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
      end

      factory :registered_asset do
        visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      end
    end

    factory :text_asset do
      after(:build, &:assert_text)
    end

    trait :with_metadata do
      pref_label "Asset with metadata"
      description ["A sample asset with a complete listing of metadata"]
      document_type { create(:list_item, pref_label: "Document type") }
      first_document_sub_type { create(:list_item, pref_label: "First sub-type") }
      second_document_sub_type { create(:list_item, pref_label: "Second sub-type") }
      keyword { [create(:list_item, pref_label: "sample")] }
    end
  end
end
