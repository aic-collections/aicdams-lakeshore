# frozen_string_literal: true
module ApplicationHelper
  def resource_type_facets
    @resource_types.reject { |r| r.is_a?(Integer) }.sort
  end
end
