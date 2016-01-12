module NestedAttributes
  extend ActiveSupport::Concern

  module ClassMethods
    # Overrides hydra-editor method to allow passing nested parameters into a form's parameters hash
    #
    # @return [Array<Hash>] hashes of elements allowed in a form
    def build_permitted_params
      super + resources_nested_by_id + resources_nested_by_attributes + related_resources_for
    end

    private

      # Resources nested within other resources using only the id as the identifying element in the form.
      # This is expressly used when adding or removing resources that already exist
      def resources_nested_by_id
        [
          { asset_ids: [] },
          { document_ids: [] },
          { representation_ids: [] },
          { preferred_representation_ids: [] },
          { aictag_ids: [] },
          { tagcat_ids: [] },
          { status_ids: [] },
          { view_ids: [] },
          { document_type_ids: [] },
          { tag_ids: [] }
        ]
      end

      # Resources nested within other resources using any of the available attributes of the resource.
      # This is used when doing any CRUD operation on a child resource using the parent resource's
      # parameter hash.
      def resources_nested_by_attributes
        [{ comments_attributes: [:id, :_destroy, :content, { category: [] }] }]
      end

      # Resources that are the subjects of related resources. For example, specifying
      # that a Work has a representation of one or more assets.
      def related_resources_for
        [:representation_for, :document_for]
      end
  end

  # These are required so that fields_for will draw a nested form.
  # See ActionView::Helpers#nested_attributes_association?
  #   https://github.com/rails/rails/blob/a04c0619617118433db6e01b67d5d082eaaa0189/actionview/lib/action_view/helpers/form_helper.rb#L1890
  def comments_attributes=(attributes)
    model.comments_attributes = attributes
  end
end
