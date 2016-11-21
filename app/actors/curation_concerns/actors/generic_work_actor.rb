# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  module Actors
    class GenericWorkActor < CurationConcerns::Actors::BaseActor
      def create(attributes)
        override_dept_created(attributes.delete("dept_created"))
        assert_asset_type(attributes.delete("asset_type"))
        super
      end

      def update(attributes)
        attributes.delete("asset_type")
        super
      end

      def assert_asset_type(type)
        if type == AICType.Text
          curation_concern.assert_text
        else
          curation_concern.assert_still_image
        end
      end

      def override_dept_created(dept)
        return unless dept
        curation_concern.dept_created = Department.find_by_citi_uid(dept).uri
      end
    end
  end
end
