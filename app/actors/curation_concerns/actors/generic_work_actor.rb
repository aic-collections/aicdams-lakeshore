# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  module Actors
    class GenericWorkActor < CurationConcerns::Actors::BaseActor
      def create(attributes)
        attributes.delete("asset_type")
        curation_concern.assert_still_image
        super
      end
    end
  end
end
