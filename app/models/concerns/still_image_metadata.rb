module StillImageMetadata
  extend ActiveSupport::Concern
  
  included do

    # TODO: These all need to be ListItem types
    property :compositing, predicate: AIC.compositing, multiple: false do |index|
      index.as :stored_searchable
    end
    
    property :light_type, predicate: AIC.lightType, multiple: false do |index|
      index.as :stored_searchable
    end
    
    property :view, predicate: AIC.view do |index|
      index.as :stored_searchable
    end

  end

end
