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
      after(:build) do |asset|
        AssetTypeAssignmentService.new(asset).assign(AICType.StillImage)
      end

      factory :department_asset do
        visibility Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
      end

      factory :registered_asset do
        visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      end

      factory :public_asset do
        visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :text_asset do
      after(:build) do |asset|
        AssetTypeAssignmentService.new(asset).assign(AICType.Text)
      end
    end

    factory :dataset_asset do
      after(:build) do |asset|
        AssetTypeAssignmentService.new(asset).assign(AICType.Dataset)
      end
    end

    factory :moving_image_asset do
      after(:build) do |asset|
        AssetTypeAssignmentService.new(asset).assign(AICType.MovingImage)
      end
    end

    factory :sound_asset do
      after(:build) do |asset|
        AssetTypeAssignmentService.new(asset).assign(AICType.Sound)
      end
    end

    factory :archive_asset do
      after(:build) do |asset|
        AssetTypeAssignmentService.new(asset).assign(AICType.Archive)
      end
    end

    # @todo Make this a default for all build actions?
    trait :with_id do
      after(:build) do |asset|
        asset.id = SecureRandom.uuid unless asset.id.present?
      end
    end

    trait :with_intermediate_file_set do
      after(:create) do |asset|
        asset.members << FactoryGirl.create(:intermediate_file_set)
      end
    end

    trait :with_original_file_set do
      after(:create) do |asset|
        asset.members << FactoryGirl.create(:original_file_set)
      end
    end

    trait :with_aic_depositor do
      after(:create) do |asset|
        asset.aic_depositor = FactoryGirl.create(:aic_user)
      end
    end

    trait :with_preservation_file_set do
      after(:create) do |asset|
        asset.members << FactoryGirl.create(:preservation_file_set)
      end
    end

    trait :with_legacy_file_set do
      after(:create) do |asset|
        asset.members << FactoryGirl.create(:legacy_file_set)
      end
    end

    trait :with_doctype_metadata do
      pref_label                   "Asset with doctype"
      description                  ["A sample asset with a complete listing of metadata"]
      date_modified                 Date.parse("October 31, 2016")
      date_uploaded                 Date.parse("October 30, 2016")
      document_type_uri            "http://definitions.artic.edu/doctypes/DevelopmentStillImage"
      keyword                      { [create(:list_item, pref_label: "sample keyword").uri] }
      view                         { [create(:list_item, pref_label: "sample view").uri] }
      capture_device               "capture device"
      digitization_source          { create(:list_item, pref_label: "digitizaton source").uri }
      legacy_uid                   ["legacy_uid1", "legacy_uid2"]
      compositing                  { create(:list_item, pref_label: "compositing").uri }
      imaging_uid                  ["imaging_uid"]
      light_type                   { create(:list_item, pref_label: "light type").uri }
      transcript                   "a transcript"
      batch_uid                    "batch_uid"
      alt_label                    ["Alternative labels"]
      language                     ["English"]
      view_notes                   ["view note 1", "view note 2"]
      visual_surrogate             "a visual surrogate"
    end

    trait :with_doctype_and_subtype_metadata do
      pref_label                   "Asset with doctype and subtype"
      description                  ["A sample asset with a complete listing of metadata"]
      date_modified                 Date.parse("October 31, 2016")
      date_uploaded                 Date.parse("October 30, 2016")
      document_type_uri            "http://definitions.artic.edu/doctypes/GeneralStillImage"
      first_document_sub_type_uri  "http://definitions.artic.edu/doctypes/IntResStillImage"
      keyword                      { [create(:list_item, pref_label: "sample keyword").uri] }
      view                         { [create(:list_item, pref_label: "sample view").uri] }
      capture_device               "capture device"
      digitization_source          { create(:list_item, pref_label: "digitizaton source").uri }
      legacy_uid                   ["legacy_uid1", "legacy_uid2"]
      compositing                  { create(:list_item, pref_label: "compositing").uri }
      imaging_uid                  ["imaging_uid"]
      light_type                   { create(:list_item, pref_label: "light type").uri }
      transcript                   "a transcript"
      batch_uid                    "batch_uid"
      alt_label                    ["Alternative labels"]
      language                     ["English"]
      view_notes                   ["view note 1", "view note 2"]
      visual_surrogate             "a visual surrogate"
    end

    trait :with_metadata do
      pref_label                   "Asset with metadata"
      description                  ["A sample asset with a complete listing of metadata"]
      date_modified                 Date.parse("October 31, 2016")
      updated                       Date.parse("October 31, 2016")
      date_uploaded                 Date.parse("October 30, 2016")
      created                       Date.parse("October 30, 2016")
      document_type_uri            "http://definitions.artic.edu/doctypes/Imaging"
      first_document_sub_type_uri  "http://definitions.artic.edu/doctypes/EventPhotography"
      second_document_sub_type_uri "http://definitions.artic.edu/doctypes/Lecture"
      keyword                      { [create(:list_item, pref_label: "sample keyword").uri] }
      view                         { [create(:list_item, pref_label: "sample view").uri] }
      capture_device               "capture device"
      digitization_source          { create(:list_item, pref_label: "digitizaton source").uri }
      legacy_uid                   ["legacy_uid1", "legacy_uid2"]
      compositing                  { create(:list_item, pref_label: "compositing").uri }
      imaging_uid                  ["imaging_uid"]
      light_type                   { create(:list_item, pref_label: "light type").uri }
      transcript                   "a transcript"
      batch_uid                    "batch_uid"
      alt_label                    ["Alternative labels"]
      language                     ["English"]
      publish_channel_uris         ["http://definitions.artic.edu/publish_channel/Web"]
      view_notes                   ["view note 1", "view note 2"]
      visual_surrogate             "a visual surrogate"
      external_resources           ["http://www.google.com"]
    end

    trait :with_license_metadata do
      copyright_representatives { [create(:agent, pref_label: "Judge Wopner").uri] }
      licensing_restrictions { [create(:list_item, pref_label: "licensing restriction").uri] }
    end
  end
end
