module StillImageMetadata
  extend ActiveSupport::Concern
  
  included do

    # TODO: this needs to be singular: enforce cardinality on AT resources
    property :compositing, predicate: AIC.compositing, multiple: true, class_name: ListItem

    # TODO: this needs to be singular: enforce cardinality on AT resources
    property :light_type, predicate: AIC.lightType, multiple: true, class_name: ListItem
    
    property :view, predicate: AIC.view, class_name: ListItem

  end

end
