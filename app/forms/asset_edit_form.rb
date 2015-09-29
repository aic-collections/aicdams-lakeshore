class AssetEditForm < AssetPresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions
  include NestedAttributes

  self.terms = AssetPresenter.terms - [:uid]
  
  protected

  # Override HydraEditor::Form to treat nested attbriutes accordingly
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
