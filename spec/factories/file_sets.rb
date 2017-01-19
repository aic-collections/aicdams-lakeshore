# frozen_string_literal: true
FactoryGirl.define do
  factory :file_set do
    transient do
      user { FactoryGirl.create(:user1) }
      content nil
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToFileSet.call(file, evaluator.content)
      end
    end

    factory :department_file do
      visibility Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    end

    factory :registered_file do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end

    factory :file_set_with_file do
      after(:build) do |file, _evaluator|
        file.title = ['testfile']
      end
      after(:create) do |file, evaluator|
        if evaluator.content
          Hydra::Works::UploadFileToFileSet.call(file, evaluator.content)
        end
        FactoryGirl.create(:still_image_asset, user: evaluator.user).members << file
      end
    end

    factory :original_file_set do
      after(:build) do |file|
        file.type << AICType.OriginalFileSet
      end
    end

    factory :intermediate_file_set do
      after(:build) do |file|
        file.type << AICType.IntermediateFileSet
      end
    end

    factory :preservation_file_set do
      after(:build) do |file|
        file.type << AICType.PreservationMasterFileSet
      end
    end

    factory :legacy_file_set do
      after(:build) do |file|
        file.type << AICType.LegacyFileSet
      end
    end

    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
