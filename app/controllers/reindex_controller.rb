class ReindexController < ActionController::Base

  before_filter :parse_json, only: [:update]

  # Updates the index of a set of objects, given their ids
  def update
    if reindex_submitted_ids
      render nothing: true, status: :ok
    else
      render nothing: true, status: :bad_request
    end
  end

  private

    def parse_json
      @json = JSON.parse(request.body.read) || []
    end

    def reindex_submitted_ids
      return false if @json.empty? || !@json.kind_of?(Array)
      @json.map { |id| Sufia.queue.push(UpdateIndexJob.new(id)) }
    end

end
