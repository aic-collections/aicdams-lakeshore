class Annotation < ActiveFedora::Base

  type ::AICType.Annotation
  
  property :content, predicate: ::AIC.content, multiple: false do |index|
    index.as :stored_searchable
  end 

end
