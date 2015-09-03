class Comment < Annotation
  
  def self.aic_type
    super << AICType.Comment
  end

  type aic_type
  
  has_many :generic_files, inverse_of: :comments, class_name: "GenericFile"

  # TODO: This needs to be a ListItem
  property :category, predicate: AIC.category do |index|
    index.as :stored_searchable
  end

end
