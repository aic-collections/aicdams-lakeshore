module NestedAttributes
  extend ActiveSupport::Concern

  module ClassMethods

    def build_permitted_params
      permitted = super
      permitted << { comments_attributes: permitted_annotation_params }
      permitted << { tags_attributes: permitted_annotation_params }
      permitted
    end

    def permitted_annotation_params
      [ :id, :_destroy, :content, { category: [] } ]
    end

  end

  # These are required so that fields_for will draw a nested form.
  # See ActionView::Helpers#nested_attributes_association?
  #   https://github.com/rails/rails/blob/a04c0619617118433db6e01b67d5d082eaaa0189/actionview/lib/action_view/helpers/form_helper.rb#L1890
  
  def comments_attributes= attributes
    model.comments_attributes= attributes
  end

  def tags_attributes= attributes
    model.tags_attributes= attributes
  end

end
