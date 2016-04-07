class Resource < ActiveFedora::Base
  include ResourceMetadata
  include Validations
  include WithStatus

  def self.aic_type
    [AICType.Resource]
  end

  type aic_type

  private

    # Returns the correct type class for attributes when loading an object from Solr
    # Catches malformed dates that will not parse into DateTime, see #198
    def adapt_single_attribute_value(value, attribute_name)
      AttributeValueAdapter.call(value, attribute_name) || super
    rescue ArgumentError
      "#{value} is not a valid date"
    end
end
