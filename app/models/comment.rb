class Comment < Annotation
  
  type ::AICType.Comment
  has_many :generic_files, inverse_of: :comments, class_name: "GenericFile"

  property :category, predicate: ::AIC.category do |index|
    index.as :stored_searchable
  end

end
