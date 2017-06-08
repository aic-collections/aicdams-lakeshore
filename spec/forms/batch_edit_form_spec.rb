# frozen_string_literal: true
require 'rails_helper'

describe BatchEditForm do
  let(:ability) { Ability.new(nil) }
  let(:batch)   { [asset1.id, asset2.id, asset3.id] }
  let(:form)    { described_class.new(GenericWork.new, ability, batch) }

  describe "building the form" do
    before { index_assets(asset1, asset2, asset3) }

    context "with empty fields" do
      let(:asset1) { build(:asset, :with_id, pref_label: "Asset1") }
      let(:asset2) { build(:asset, :with_id, pref_label: "Asset2") }
      let(:asset3) { build(:asset, :with_id, pref_label: "Asset3") }

      specify do
        expect(form.model.publish_channel_uris).to be_empty
        expect(form.model.alt_label).to be_empty
        expect(form.model.language).to be_empty
        expect(form.model.publisher).to be_empty
        expect(form.model.status_uri).to eq(ListItem.active_status.uri)
        expect(form.names).to contain_exactly("Asset1", "Asset2", "Asset3")
        expect(form.uris_for("uri")).to be_nil
        expect(form.uri_for("uri")).to be_nil
        expect(form.model.visibility).to eq("department")
      end
    end

    context "with differing values" do
      let(:asset1) { build(:asset, :with_id, pref_label: "Asset1", language: ["English"]) }
      let(:asset2) { build(:asset, :with_id, pref_label: "Asset2", language: ["Russian"]) }
      let(:asset3) { build(:registered_asset, :with_id, pref_label: "Asset3", language: ["Chinese"]) }

      specify do
        expect(form.model.visibility).to eq("department")
        expect(form.model.language).to eq(["English", "Chinese", "Russian"])
      end
    end

    context "with similar values" do
      let(:asset1) { build(:registered_asset, :with_id, pref_label: "Asset1", language: ["English"]) }
      let(:asset2) { build(:registered_asset, :with_id, pref_label: "Asset2", language: ["English"]) }
      let(:asset3) { build(:registered_asset, :with_id, pref_label: "Asset3", language: ["English"]) }

      specify do
        expect(form.model.visibility).to eq("authenticated")
        expect(form.model.language).to eq(["English"])
      end
    end
  end

  describe "::model_attributes" do
    let(:attributes) { { publish_channel_uris: ["", AICPublishChannel.InMuseumApps.to_s] } }
    subject { described_class.model_attributes(ActionController::Parameters.new(attributes)) }
    it { is_expected.to eq("publish_channel_uris" => [AICPublishChannel.InMuseumApps.to_s]) }
  end

  describe "::build_permitted_params" do
    subject { described_class }
    its(:build_permitted_params) { is_expected.to include({ publish_channel_uris: [] }, :visibility) }
  end
end
