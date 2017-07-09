# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  module Actors
    class GenericWorkActor < CurationConcerns::Actors::BaseActor
      def create(attributes)
        override_dept_created(attributes.delete("dept_created"))
        asset_type = RDF::URI(attributes.delete("asset_type"))
        AssetTypeAssignmentService.new(curation_concern).assign(asset_type)
        apply_dates(updated: attributes.delete("updated"), created: attributes.delete("created"))
        assign_copyright_representatives(attributes.delete("copyright_representatives"))
        super
      end

      def update(attributes)
        attributes.delete("asset_type")
        apply_dates(updated: attributes.delete("updated"), created: attributes.delete("created"))
        assign_copyright_representatives(attributes.delete("copyright_representatives"))
        super
      end

      def override_dept_created(dept)
        return unless dept
        curation_concern.dept_created = Department.find_by_citi_uid(dept).uri
      end

      # @param [Hash] terms
      # Attempts to parse the values of each key into dates and set the object's property using
      # the key as the property. A failure will not change the existing value and a message is
      # written to the log.
      # Note: Does not work with multivalued properties.
      def apply_dates(terms)
        terms.each do |k, v|
          next unless v.present?
          parse_date(k, v)
        end
      end

      def assign_copyright_representatives(reps)
        return if reps.nil?
        new_representatives = build_representatives(reps)
        curation_concern.copyright_representative_uris = new_representatives
      end

      private

        def parse_date(property, value)
          curation_concern.send("#{property}=", Date.parse(value))
        rescue ArgumentError
          Rails.logger.error("Unable to parse #{value} into date for property #{property}")
        end

        def build_representatives(reps)
          reps.map do |id|
            Agent.find(id).uri
          end
        end
    end
  end
end
