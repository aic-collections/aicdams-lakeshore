# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::Actors::GenericWorkActor do
  let(:user)  { create(:user1) }
  let(:work)  { GenericWork.new }
  let(:actor) { CurationConcerns::CurationConcern.actor(work, user) }

  subject { work.reload }

  describe "::actor_factory" do
    subject { CurationConcerns::CurationConcern.actor_factory }
    it { is_expected.to eq(Sufia::ActorFactory) }
  end

  describe "#create" do
    let(:doc_type) { create(:list_item, pref_label: 'Document Type') }
    let(:parameters) do
      { "asset_type" => "still_image",
        "document_type_uris" => [doc_type.uri],
        "pref_label" => "",
        "created" => "",
        "description" => [""],
        "language" => [""],
        "publisher" => [""],
        "rights_holder_uris" => [""],
        "capture_device" => "",
        "status" => "",
        "digitization_source_uri" => "",
        "compositing_uri" => "",
        "light_type_uri" => "",
        "view_uris" => [""],
        "keyword_uris" => [""],
        "visibility_during_embargo" => "restricted",
        "embargo_release_date" => "2016-05-19",
        "visibility_after_embargo" => "open",
        "visibility_during_lease" => "open",
        "lease_expiration_date" => "2016-05-19",
        "visibility_after_lease" => "restricted",
        "visibility" => "restricted"
      }
    end
    before { actor.create(parameters) }
    its(:type) { is_expected.to include(AICType.StillImage) }
  end
end
