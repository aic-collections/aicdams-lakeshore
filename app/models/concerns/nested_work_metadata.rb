module NestedWorkMetadata
  extend ActiveSupport::Concern
  
  included do
    has_and_belongs_to_many :assets, predicate: AIC.hasConstituent, class_name: "GenericFile", inverse_of: :works
    accepts_nested_attributes_for :assets, allow_destroy: false
  end

end
