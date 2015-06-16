class Annotation < ActiveFedora::Base

  include ActiveFedora::Validations  
  validates_presence_of :content

  type [::AICType.Annotation, AICType.Resource]
  
  property :content, predicate: ::AIC.content, multiple: false do |index|
    index.as :stored_searchable
  end 

end
