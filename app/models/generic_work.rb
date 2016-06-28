# frozen_string_literal: true
class GenericWork < Resource
  include ::CurationConcerns::WorkBehavior
  include Sufia::WorkBehavior
  include StillImageMetadata
  include TextMetadata
  include AssetMetadata
  include Permissions

  self.human_readable_type = 'Asset'
  self.indexer = AssetIndexer

  def self.aic_type
    super << AICType.Asset
  end

  type type + aic_type

  before_create :status_is_active
  validate :uid_matches_id, on: :update
  before_destroy :asset_cannot_be_referenced

  def still_image?
    type.include? AICType.StillImage
  end

  def text?
    type.include? AICType.Text
  end

  def assert_still_image
    return true if still_image?
    return false if text?
    t = get_values(:type)
    t << AICType.StillImage
    set_value(:type, t)
  end

  def assert_text
    return true if text?
    return false if still_image?
    t = get_values(:type)
    t << AICType.Text
    set_value(:type, t)
  end

  def prefix
    return "TX" if text?
    return "SI" if still_image?
    raise ArgumentError, "Can't assign a prefix without a type"
  end

  # Overrides CurationConcerns::Noid to set both #id and #uid to the minted uid
  def assign_id
    self.uid = service.mint
  end

  def status_is_active
    self.status = StatusType.active
  end

  def uid_matches_id
    errors.add :uid, 'must match id' if uid != id
  end

  def asset_cannot_be_referenced
    if representing_resource.representing?
      errors[:representations] = "are assigned to this resource"
    end
    return false unless errors.empty?
  end

  # CurationConcerns' title is required, and is multivalued
  # We will allow it be empty, or return the pref. label as an array
  def title
    return [] unless pref_label
    [pref_label]
  end

  # Used by Sufia::WorkIndexer, although may not be required
  # Aliased to document_type
  def resource_type
    document_type
  end

  private

    def service
      @service ||= UidMinter.new(prefix)
    end

    def representing_resource
      @representing_resource ||= RepresentingResource.new(id)
    end
end
