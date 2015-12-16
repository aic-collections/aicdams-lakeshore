class HomepageController < ApplicationController
  include Sufia::HomepageController

  def index
    super
    resource_types
  end

  protected

    def resource_types
      results, _junk = search_results({ q: '', rows: 0 }, (search_params_logic - [:show_only_generic_files]))
      @resource_types = results["facet_counts"]["facet_fields"][Solrizer.solr_name("aic_type", :facetable)]
    end
end
