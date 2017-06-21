# frozen_string_literal: true
class CollectionForm < Sufia::Forms::CollectionForm
  delegate :depositor, :dept_created, :permissions, to: :model
  include HydraEditor::Form::Permissions
  include PropertyPermissions

  attr_reader :current_ability

  def self.terms
    [:title, :representative_id, :thumbnail_id, :publish_channel_uris, :collection_type_uri]
  end

  # @param [Collection] model
  # @param [Ability] current_ability
  # Overrides HydraEditor where the class is originally initialized so that we can add current_ability
  def initialize(model, current_ability)
    @model = model
    @current_ability = current_ability
    initialize_fields
  end

  def primary_terms
    [:title, :publish_channel_uris, :collection_type_uri]
  end

  def uris_for(term)
    model.send(term).map(&:uri).map(&:to_s)
  end

  def uri_for(term)
    return unless model.send(term)
    model.send(term).uri.to_s
  end
end
