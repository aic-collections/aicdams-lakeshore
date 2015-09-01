module TextMetadata
  extend ActiveSupport::Concern
  
  included do

    property :transcript, predicate: AIC.transcript, multiple: false do |index|
      index.as :stored_searchable
    end

  end

end
