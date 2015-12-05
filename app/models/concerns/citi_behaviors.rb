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
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end
  end

  def registered?
    true
  end

  def featureable?
    false
  end

end
