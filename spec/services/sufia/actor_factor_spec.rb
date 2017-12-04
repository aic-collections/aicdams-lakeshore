# frozen_string_literal: true
require 'rails_helper'

describe Sufia::ActorFactory do
  describe ".stack_actors" do
    let(:curation_concern) { build(:asset) }
    subject { described_class.stack_actors(curation_concern) }

    it do
      is_expected.to include(
        ReplaceFileActor,
        CreateAssetsActor
      )
    end
  end

  describe ".model_actor" do
    subject { described_class.model_actor(curation_concern) }
    context "with a non-asset" do
      let(:curation_concern) { build(:non_asset) }
      it { is_expected.to be(CitiResourceActor) }
    end

    context "with an asset" do
      let(:curation_concern) { build(:asset) }
      it { is_expected.to be(AssetActor) }
    end
  end
end
