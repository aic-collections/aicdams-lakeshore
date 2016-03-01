module CitiResourceMetadata
  extend ActiveSupport::Concern

  class_methods do
    def find_by_citi_uid(id)
      where(Solrizer.solr_name("citi_uid", :symbol) => id).first
    end
  end

  included do
    property :citi_uid, predicate: AIC.citiUid, multiple: false do |index|
      index.as :symbol
    end
  end
end
