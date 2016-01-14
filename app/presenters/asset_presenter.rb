class AssetPresenter < Sufia::GenericFilePresenter
  delegate :documents, :representations, :preferred_representations, :assets, :representing?, to: :representing_resource

  self.terms = [
    :uid,
    :legacy_uid,
    :document_type,
    :status,
    :resource_created,
    :dept_created,
    :resource_updated,
    :description,
    :batch_uid,
    :language,
    :publisher,
    :rights_holder,
    :tag,
    :created_by,
    :compositing,
    :light_type,
    :view,
    :asset_capture_device,
    :digitization_source
  ]

  # TODO: needs to show either representation, preferred representation, or document
  def brief_terms
    [
      #:relation,
      :asset_type,
      :uid,
      :pref_label
    ]
  end

  def asset_type
    return "Image" if model.still_image?
    return "Text Document" if model.text?
  end

  def views
    model.view.map(&:pref_label).join(", ")
  end

  def document_types
    model.document_type.map(&:pref_label).join(", ")
  end

  def tags
    model.tag.map(&:pref_label).join(", ")
  end

  private

    def representing_resource
      @representing_resource ||= RepresentingResource.new(model.id)
    end
end
