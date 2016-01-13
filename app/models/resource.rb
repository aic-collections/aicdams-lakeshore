class Resource < ActiveFedora::Base
  include ResourceMetadata
  include Validations

  def self.aic_type
    [AICType.Resource]
  end

  type aic_type

  private

    # ActiveFedora casts values into DateTime objects
    # However, when comming from CITI, these values are sometimes suspect, see issue #198
    def adapt_single_attribute_value(value, attribute_name)
      super
    rescue ArgumentError
      "#{value} is not a valid date"
    end
end
