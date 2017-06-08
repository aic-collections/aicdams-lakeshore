# frozen_string_literal: true
class BatchEditForm < Sufia::Forms::BatchEditForm
  include PropertyPermissions

  attr_reader :documents

  self.terms = [
    :publish_channel_uris, :status_uri, :alt_label, :language, :publisher
  ]

  # Call the method on BatchUploadForm because including the AssetFormBehaviors module was not working.
  def self.build_permitted_params
    BatchUploadForm.build_permitted_params + [:visibility]
  end

  def publish_channel_uris
    []
  end

  def uri_for(term)
    # noop
  end

  def uris_for(term)
    # noop
  end

  def names
    documents.map(&:pref_label).flatten
  end

  private

    # @param [Array<String>] batch a list of document ids in the batch
    # Uses Solr-based records to assemble combined properties for each asset in the batch
    def initialize_combined_fields(batch)
      query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids(batch)
      @documents = ActiveFedora::SolrService.query(query, rows: batch.count).map { |hit| SolrDocument.new(hit) }
      combined_fields.each do |term|
        model.send("#{term}=", @documents.map(&term).flatten.uniq)
      end

      model.status = combined_status
      model.visibility = combined_visibility
    end

    def combined_fields
      terms - [:publish_channel_uris, :status_uri]
    end

    # @todo return the status of the combined assets, only if they all agree. Otherwise, return active.
    def combined_status
      ListItem.active_status.uri
    end

    def combined_visibility
      values = documents.map(&:visibility).uniq
      return if values.count > 1
      values.first
    end
end
