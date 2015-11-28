# Resources loaded into Fedora from CITI. Although they are defined ActiveFedora models, they operate
# slightly differently than Sufia's other classes. These are some basic methods
# that allow them to behave with other objects.
module CitiBehaviors
  extend ActiveSupport::Concern
  include LakeshorePermissions

  class_methods do
    def indexer
      ::CitiIndexer
    end

    def visibility
      "department"
    end
  end

  def registered?
    false
  end
  
  def featureable?
    false
  end

end
