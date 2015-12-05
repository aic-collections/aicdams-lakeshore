class GenericFile < Resource
  include Sufia::GenericFile
  include StillImageMetadata
  include TextMetadata
  include AssetMetadata
  include Status
  include LakeshorePermissions
  include LakeshoreVisibility

  def self.aic_type
    super << AICType.Asset
  end

  type aic_type

  before_create :status_is_active
  validate :uid_matches_id, on: :update
  validate :public_cannot_read
  before_destroy :asset_cannot_be_referenced

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

  def prefix
    return "TX" if is_text?
    return "SI" if is_still_image?
    raise ArgumentError, "Can't assign a prefix without a type"
  end

  def self.indexer
    ::AssetIndexer
  end

  # Overrides Sufia::Noid to set both #id and #uid to the minted uid
  def assign_id
    self.uid = service.mint
  end

  def status_is_active
    self.status = StatusType.active
  end

  def uid_matches_id
    self.errors.add :uid, 'must match id' if self.uid != self.id
  end

  # TODO: Move to module if other classes require this
  def public_cannot_read
    self.errors[:read_users] = "Public cannot have read access" if read_groups.include?("public")
  end

  def apply_depositor_metadata(depositor)
    super
    self.dept_created = user_dept(depositor) || Sufia.config.default_department
    true
  end

  def asset_cannot_be_referenced
    if representing_resource.representing?
      self.errors[:representations] = "are assigned to this resource"
    end    
    return false unless self.errors.empty?
  end

  private

    # Overrides Sufia::Noid#service
    def service
      @service ||= UidMinter.new(prefix)
    end

    def representing_resource
      @representing_resource ||= RepresentingResource.new(self.id)
    end

    # TODO: Replace once departments are imported from CITI
    def user_dept(depositor)
      case depositor
      when User
        depositor.department
      when Array
        User.find(depositor.first).department
      else
        User.find(depositor).department
      end
    rescue
      nil
    end
end
