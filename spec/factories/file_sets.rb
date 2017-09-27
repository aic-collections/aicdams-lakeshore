# frozen_string_literal: true
FactoryGirl.define do
  factory :file_set do
    transient do
      user { FactoryGirl.create(:user1) }
      content nil
      parent nil
    end

    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user)
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToFileSet.call(file, evaluator.content)
      end
    end

    factory :intermediate_file_set, aliases: [:department_file] do
      after(:build) do |file|
        file.type << AICType.IntermediateFileSet
      end

      factory :registered_file do
        after(:build) do |file|
        end
      end

      factory :public_file do
        after(:build) do |file|
        end
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
    end

    factory :original_file_set do
      after(:build) do |file|
        file.type << AICType.OriginalFileSet
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

    factory :incomplete_file_set do
      after(:create) do |file|
        file.edit_groups = []
        file.read_groups = []
        file.save
      end
    end
  end
end
