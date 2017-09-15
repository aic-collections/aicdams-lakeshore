# frozen_string_literal: true
# Common actor for all CITI resources
class CitiResourceActor < CurationConcerns::Actors::BaseActor
  # @param [Hash] attributes from the form
  def update(attributes)
    unless attributes.fetch("preferred_representation_uri", "").present?
      attributes["preferred_representation_uri"] = attributes.fetch("representation_uris", [""]).first
    end
    super
  end

  protected

    def save
      notify_citi if curation_concern.preferred_representation_changed?
      super
    end

    def notify_citi
      if curation_concern.preferred_representation.nil?
        CitiNotificationJob.perform_later(nil, curation_concern)
      elsif curation_concern.preferred_representation.intermediate_file_set.present?
        CitiNotificationJob.perform_later(curation_concern.preferred_representation.intermediate_file_set.first, curation_concern)
      end
    end
end
