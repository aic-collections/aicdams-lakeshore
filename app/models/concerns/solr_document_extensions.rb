# frozen_string_literal: true
module SolrDocumentExtensions
  extend ActiveSupport::Concern
  include Permissions::Readable

  include SolrDocumentExtensions::Agent
  include SolrDocumentExtensions::Work
  include SolrDocumentExtensions::Exhibition
  include SolrDocumentExtensions::Place

  def pref_label
    Array(self[Solrizer.solr_name('pref_label', :stored_searchable)]).first
  end

  def uid
    Array(self[Solrizer.solr_name('uid', :symbol)]).first
  end

  def citi_uid
    Array(self[Solrizer.solr_name('uid', :symbol)]).first
  end

  def fedora_uri
    Array(self[Solrizer.solr_name('fedora_uri', :symbol)]).first
  end

  def main_ref_number
    Array(self[Solrizer.solr_name('main_ref_number', :stored_searchable)]).first
  end

  def visibility
    @visibility ||= if read_groups.include? Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED
                      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
                    else
                      Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
                    end
  end

  # Overrides CurationConcerns::SolrDocumentBehavior
  def title_or_label
    pref_label
  end
end
