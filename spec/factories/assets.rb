FactoryGirl.define do
  factory :generic_file, aliases: [:asset_without_type] do
    transient do
      user { FactoryGirl.create(:user1) }
    end

    after(:build) do |asset, evaluator|
      asset.apply_depositor_metadata(evaluator.user)
    end

    factory :still_image_asset, aliases: [:asset] do
      after(:build) do |asset, _evaluator|
        asset.assert_still_image
      end

      factory :department_file do
        visibility LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
      end

      factory :registered_file do
        visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      end
    end

    factory :text_asset do
      after(:build) do |asset, _evaluator|
        asset.assert_text
      end
    end
  end
end
