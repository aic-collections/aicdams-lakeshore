class Comment < Annotation
  
  type ::AICType.Comment
  has_many :generic_files, inverse_of: :comments, class_name: "GenericFile"

end
