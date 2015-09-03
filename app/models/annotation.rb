class Annotation < Resource
  include ActiveFedora::Validations  
  validates_presence_of :content

  def self.aic_type
    super << AICType.Annotation
  end

  type aic_type
  
  property :content, predicate: AIC.content, multiple: false do |index|
    index.as :stored_searchable
  end 

end
