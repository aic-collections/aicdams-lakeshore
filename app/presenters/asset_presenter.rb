# frozen_string_literal: true
class AssetPresenter < Sufia::WorkShowPresenter
  delegate :documents, :representations, :preferred_representations, :assets, :representing?, to: :representing_resource

  def self.terms
    [
      :uid,
      :legacy_uid,
      :document_type,
      :status,
      :created,
      :dept_created,
      :updated,
      :description,
      :batch_uid,
      :language,
      :publisher,
      :pref_label,
      :rights_holder,
      :keyword,
      :created_by,
      :compositing,
      :light_type,
      :view,
      :capture_device,
      :digitization_source
    ]
  end

  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

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

  private

    def representing_resource
      @representing_resource ||= RepresentingResource.new(model.id)
    end
end
