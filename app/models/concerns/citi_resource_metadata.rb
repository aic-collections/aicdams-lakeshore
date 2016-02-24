module CitiResourceMetadata
  extend ActiveSupport::Concern

  included do
    property :citi_uid, predicate: AIC.citiUid, multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
