# Resources loaded into Fedora from CITI. Although they are defined ActiveFedora models, they operate
# slightly differently than Sufia's other classes. These are some basic methods
# that allow them to behave with other objects.
module CitiBehaviors
  extend ActiveSupport::Concern

  class_methods do
    def indexer
      ::CitiIndexer
    end

    def visibility
      "open"
    end
  end  

  def public?
    true
  end

  def registered?
    false
  end
  
  def featureable?
    false
  end

end
