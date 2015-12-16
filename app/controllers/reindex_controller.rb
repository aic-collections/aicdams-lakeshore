class ReindexController < ActionController::Base
  before_action :parse_json, only: [:update]

  # Updates the index of a set of objects, given their ids
  def update
    if reindex_submitted_ids
      head :no_content
    else
      head :bad_request
    end
  end

  private

    def parse_json
      @json = JSON.parse(request.body.read) || []
    end

    def reindex_submitted_ids
      return false if @json.empty? || !@json.is_a?(Array)
      @json.map { |id| Sufia.queue.push(UpdateIndexJob.new(id)) }
    end
end
