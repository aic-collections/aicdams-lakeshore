# frozen_string_literal: true
class Sufia::HomepageController < ApplicationController
  include Sufia::HomepageControllerBehavior

  def index
    super
    resource_types
  end

  protected

    # Build a list of current aic_type facets to use in advanced search form
    def resource_types
      results, _junk = search_results(q: '', rows: 0)
      @resource_types = results["facet_counts"]["facet_fields"][Solrizer.solr_name("aic_type", :facetable)]
    end
end
