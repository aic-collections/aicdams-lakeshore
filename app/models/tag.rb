class Tag < Annotation
  
  type ::AICType.Tag

  has_many :generic_files, inverse_of: :aictags, class_name: "GenericFile"
  has_and_belongs_to_many :tagcats, predicate: AIC.category, class_name: "TagCat", inverse_of: :aictags

  accepts_nested_attributes_for :tagcats, allow_destroy: true

  def attributes= attributes
    attributes["tagcats_attributes"].reject! { |k,v| v["pref_label"].empty? if v && v["pref_label"] } if attributes["tagcats_attributes"]
    super(attributes)
  end

end
