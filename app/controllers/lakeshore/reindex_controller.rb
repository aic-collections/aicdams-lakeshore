# frozen_string_literal: true
module Lakeshore
  class ReindexController < APIController
    before_action :parse_json, only: [:create]

    # Updates the index of a set of objects, given their ids
    def create
      if reindex_submitted_ids
        head :no_content
      else
        head :bad_request
      end
    end

    private

      def parse_json
        @json = JSON.parse(request.raw_post) || []
      rescue JSON::ParserError
        head :bad_request
      end

      def reindex_submitted_ids
        return false if @json.empty? || !@json.is_a?(Array)
        @json.each do |id|
          UpdateIndexJob.perform_later(id, params.fetch("queue", nil)) unless deleted_from_solr?(id)
        end
      end

      def deleted_from_solr?(id)
        return if ActiveFedora::Base.exists?(id)
        Blacklight.default_index.connection.delete_by_id(id)
      end
  end
end
