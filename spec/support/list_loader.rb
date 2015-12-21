module ListLoader
  def load_lists
    status
    digitization_source
    document_type
    tag
    comment_category
    conservation_document_type
    conservation_image_type
    compositing
    light_type
    view
  end

  def status
    raise "Status list already exists!" unless List.where(pref_label: "Status").empty?
    list = List.new(pref_label: "Status")
    list.members = [invalid, deleted, disabled, active, archived]
    list.save
  end

  def invalid
    StatusType.new.tap do |s|
      s.pref_label = "Invalid"
      s.identifier = -2
      s.description = ["Record is missing some critical fields (such as from an unclean import from a foreign system) and should be reviewed and corrected or replaced before being used by any application."]
    end
  end

  def deleted
    StatusType.new.tap do |s|
      s.pref_label = "Deleted"
      s.identifier = -1
      s.description = ["Record has been deleted by an application. Use this status instead of deleting records from a table, unless these records are duplicated or corrupted. Some application admins may be able to 'undelete' records. Deleted records can only be viewed by admins. The only modification possible is to their status."]
    end
  end

  def disabled
    StatusType.new.tap do |s|
      s.pref_label = "Disabled"
      s.identifier = 0
      s.description = ["Record is valid but not viewable by end users. Other records relating to this one should not display references to it to non-admin users. In some cases (such as item belonging to a category with 'disabled' status) the application can decide not to show the related records either. New relations cannot be created."]
    end
  end

  def active
    StatusType.new.tap do |s|
      s.pref_label = "Active"
      s.identifier = 1
      s.description = ["Record is available for use."]
    end
  end

  def archived
    StatusType.new.tap do |s|
      s.pref_label = "Archived"
      s.identifier = 2
      s.description = ["Record is available for view and discovery. No modifications can be made to it, except to its status by the owner or admins. Special access controls (e.g. hide from public users) and/or functionality (such as a special storage location) can be attached to this status."]
    end
  end

  def digitization_source
    raise "Digitization source list already exists!" unless DigitizationSource.all.empty?
    list = List.new(pref_label: "Digitization Source")
    list.members = [
      ListItem.new(pref_label: "Sample Digitization Source List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def document_type
    raise "Document type list already exists!" unless DocumentType.all.empty?
    list = List.new(pref_label: "Document Type")
    list.members = [
      ListItem.new(pref_label: "Sample Document Type List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def tag
    raise "Tag list already exists!" unless Tag.all.empty?
    list = List.new(pref_label: "Tag")
    list.members = [
      ListItem.new(pref_label: "Sample Tag List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def comment_category
    raise "Comment category list already exists!" unless CommentCategory.all.empty?
    list = List.new(pref_label: "Comment Category")
    list.members = [
      ListItem.new(pref_label: "Sample Comment Category List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def conservation_document_type
    raise "Conservation document type list already exists!" unless ConservationDocumentType.all.empty?
    list = List.new(pref_label: "Conservation Document Type")
    list.members = [
      ListItem.new(pref_label: "Sample Conservation Document Type List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def conservation_image_type
    raise "Conservation image type list already exists!" unless ConservationImageType.all.empty?
    list = List.new(pref_label: "Conservation Image Type")
    list.members = [
      ListItem.new(pref_label: "Sample Conservation Image Type List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def compositing
    raise "Compositing type list already exists!" unless Compositing.all.empty?
    list = List.new(pref_label: "Compositing")
    list.members = [
      ListItem.new(pref_label: "Sample Compositing List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def light_type
    raise "Light type list already exists!" unless LightType.all.empty?
    list = List.new(pref_label: "Light Type")
    list.members = [
      ListItem.new(pref_label: "Sample Light Type List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end

  def view
    raise "View type list already exists!" unless View.all.empty?
    list = List.new(pref_label: "View")
    list.members = [
      ListItem.new(pref_label: "Sample View List Item", description: ["Sample list item for testing"])
    ]
    list.save
  end
end
