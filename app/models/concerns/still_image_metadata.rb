module StillImageMetadata
  extend ActiveSupport::Concern
  
  included do

    # TODO: this needs to be singular: enforce cardinality on AT resources
    property :compositing, predicate: AIC.compositing, multiple: true, class_name: UndefinedListItem

    # TODO: this needs to be singular: enforce cardinality on AT resources
    property :light_type, predicate: AIC.lightType, multiple: true, class_name: UndefinedListItem
    
    property :view, predicate: AIC.view, class_name: UndefinedListItem

  end

end
