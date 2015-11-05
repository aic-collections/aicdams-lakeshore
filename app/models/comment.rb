class Comment < Annotation
  
  def self.aic_type
    super << AICType.Comment
  end

  type aic_type
  
  has_many :generic_files, inverse_of: :comments, class_name: "GenericFile"

  # TODO: this needs to be singular: enforce cardinality on AT resources
  property :category, predicate: AIC.category, multiple: true, class_name: UndefinedListItem

end
