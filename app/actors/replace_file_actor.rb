# frozen_string_literal: true
class ReplaceFileActor < CurationConcerns::Actors::AbstractActor
  # noop
  delegate :create, to: :next_actor

  def update(attributes)
    updated_attributes = replace_files(attributes)
    next_actor.update(updated_attributes)
  end

  private

    def replace_files(attributes)
      return attributes unless attributes[:uploaded_files]
      attributes[:uploaded_files].delete_if { |id| FileSetReplacementService.new(curation_concern, id, user).replaced? }
      attributes
    end
end
