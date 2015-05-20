class Tag < Annotation
  
  type ::AICType.Tag
  has_many :generic_files, inverse_of: :aictags, class_name: "GenericFile"

end
