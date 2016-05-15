# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Hydra::AccessControlsEnforcement
  include CurationConcerns::SearchFilters

  def exclude_lists(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "-#{Solrizer.solr_name('has_model', :symbol)}:(\"List\")"
  end
end
