class AssetEditForm < AssetPresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions
  include NestedAttributes

  self.terms = [
    :document_type_ids, :title, :created_by, :description, :language, :publisher, :rights_holder,
    :asset_capture_device, :status_id, :digitization_source_id, :compositing_id,
    :light_type_id, :view_ids, :tag_ids
  ]

  def status_id
    return if status.nil?
    status.id
  end

  def digitization_source_id
    return if digitization_source.nil?
    digitization_source.id
  end

  def compositing_id
    return if compositing.nil?
    compositing.id
  end

  def light_type_id
    return if light_type.nil?
    light_type.id
  end

  def view_ids
    return [] if view.empty?
    view.map(&:id)
  end

  def document_type_ids
    return [] if document_type.empty?
    document_type.map(&:id)
  end

  def tag_ids
    return [] if tag.empty?
    tag.map(&:id)
  end

  protected

    # Override HydraEditor::Form to treat nested attributes accordingly
    def initialize_field(key)
      if key == :comments
        build_association(key)
      else
        super
      end
    end

  private

    def build_association(key)
      association = model.send(key)
      if association.empty?
        self[key] = Array(association.build)
      else
        association.build
        self[key] = association
      end
    end
end
