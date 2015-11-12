class Resource < ActiveFedora::Base
  include ResourceMetadata
  include Validations

  def self.aic_type
    [AICType.Resource]
  end

  type aic_type

  private

    # TODO: Remove this when projecthydra/active_fedora#939 is merged
    def adapt_single_attribute_value(value, attribute_name)
      return nil if date_attribute?(attribute_name) && !value.present?
      super
    end
end
