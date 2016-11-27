# frozen_string_literal: true
module AssetFormBehaviors
  extend ActiveSupport::Concern

  included do
    def self.build_permitted_params
      super + [
        { rights_holder_uris: [] },
        { view_uris: [] },
        { keyword_uris: [] },
        { representations_for: [] },
        { documents_for: [] },
        { publish_channel_uris: [] },
        { imaging_uid: [] },
        { view_notes: [] },
        :document_type_uri,
        :first_document_sub_type_uri,
        :second_document_sub_type_uri,
        :digitization_source_uri,
        :compositing_uri,
        :light_type_uri,
        :status_uri,
        :asset_type,
        :additional_representation,
        :additional_document,
        :uid,
        :dept_created
      ]
    end
  end
end
