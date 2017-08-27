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
      case curation_concern
      when CitiResource
        return CitiResourceActor
      when GenericWork
        return AssetActor
      else
        super
      end
    end
  end
end
