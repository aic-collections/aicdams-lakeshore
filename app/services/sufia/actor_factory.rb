# frozen_string_literal: true
# Overrides Sufia to specify our own actor stack and model_actor methods.
module Sufia
  class ActorFactory < CurationConcerns::Actors::ActorFactory
    def self.stack_actors(curation_concern)
      [AddToCitiResourceActor,
       ReplaceFileActor,
       CreateWithRemoteFilesActor,
       CreateAssetsActor,
       CurationConcerns::Actors::AddToCollectionActor,
       CurationConcerns::Actors::AddToWorkActor,
       CurationConcerns::Actors::AssignRepresentativeActor,
       CurationConcerns::Actors::AttachFilesActor,
       CurationConcerns::Actors::ApplyOrderActor,
       CurationConcerns::Actors::InterpretVisibilityActor,
       model_actor(curation_concern)]
    end

    def self.model_actor(curation_concern)
      return CitiResourceActor if curation_concern.is_a?(CitiResource)
      super
    end
  end
end
