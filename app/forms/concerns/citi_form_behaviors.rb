# frozen_string_literal: true
module CitiFormBehaviors
  extend ActiveSupport::Concern

  included do
    def representation_terms
      [:document_uris, :representation_uris, :preferred_representation_uri]
    end

    def document_uris
      model.documents.map(&:uri).map(&:to_s)
    end

    def representation_uris
      model.representations.map(&:uri).map(&:to_s)
    end

    def preferred_representation_uri
      return unless model.preferred_representation
      model.preferred_representation.uri.to_s
    end

    def self.multiple?(term)
      return true if [:document_uris, :representation_uris].include? term
      super
    end

    def self.build_permitted_params
      super + [
        { document_uris: [] },
        { representation_uris: [] },
        :preferred_representation_uri
      ]
    end
  end
end
