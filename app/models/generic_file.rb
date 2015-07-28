class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Validations
  include AssetMetadata
  include NestedMetadata

  type [AICType.Asset, AICType.Resource]

  def is_still_image?
    self.type.include? AICType.StillImage
  end

  def is_text?
    self.type.include? AICType.Text
  end

  def assert_still_image
    return true if is_still_image?
    return false if is_text?
    t = self.get_values(:type)
    t << AICType.StillImage
    self.set_value(:type, t)
  end

  def assert_text
    return true if is_text?
    return false if is_still_image?
    t = self.get_values(:type)
    t << AICType.Text
    self.set_value(:type, t)
  end

  def self.indexer
    ::AssetIndexer
  end

end
