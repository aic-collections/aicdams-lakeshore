# frozen_string_literal: true
class ReplaceFileActor < CurationConcerns::Actors::AbstractActor
  attr_reader :ingest_method

  # noop
  delegate :create, to: :next_actor

  def update(attributes)
    @ingest_method = attributes.fetch(:ingest_method, nil)
    updated_attributes = replace_files(attributes)
    next_actor.update(updated_attributes)
  end

  private

    def replace_files(attributes)
      return attributes unless attributes[:uploaded_files]
      attributes[:uploaded_files].delete_if do |id|
        FileSetReplacementService.new(curation_concern, id, user, ingest_method).replaced?
      end
      attributes
    end
end
