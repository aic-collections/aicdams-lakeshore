# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::Actors::GenericWorkActor do
  let(:user)  { create(:user1) }
  let(:work)  { GenericWork.new }
  let(:actor) { CurationConcerns::CurationConcern.actor(work, user) }

  subject { work }

  describe "::actor_factory" do
    subject { CurationConcerns::CurationConcern.actor_factory }
    it { is_expected.to eq(Sufia::ActorFactory) }
  end

  describe "#create" do
    let(:doc_type) { create(:list_item, pref_label: 'Document Type') }
    before { actor.create(parameters) }

    context "with a still image and full metadata" do
      let(:deparment) { Department.find_by_citi_uid("100") }
      let(:parameters) do
        { "asset_type" => AICType.StillImage, "document_type_uri" => doc_type.uri }
      end
      it "creates the asset" do
        expect(subject.type).to include(AICType.StillImage)
        expect(subject.dept_created).to eq(deparment)
      end
    end

    context "when overriding dept_created" do
      let(:deparment) { Department.find_by_citi_uid("200") }
      let(:parameters) do
        { "asset_type" => AICType.StillImage, "document_type_uri" => doc_type.uri, "dept_created" => "200" }
      end
      its(:dept_created) { is_expected.to eq(deparment) }
    end

    context "with a text type" do
      let(:parameters) { { "asset_type" => AICType.Text, "document_type_uri" => doc_type.uri } }
      its(:type) { is_expected.to include(AICType.Text) }
    end

    context "when parsing valid create dates" do
      let(:parameters) { { "asset_type" => AICType.Text, "created" => "July 6, 2092" } }
      its(:created) { is_expected.to be_kind_of(Date) }
    end

    context "when parsing valid update dates" do
      let(:parameters) { { "asset_type" => AICType.Text, "updated" => "July 6, 2092" } }
      its(:updated) { is_expected.to be_kind_of(Date) }
    end

    context "when parsing invalid dates" do
      let(:parameters) { { "asset_type" => AICType.Text, "updated" => "asdf" } }
      its(:updated) { is_expected.to be_nil }
    end
  end

  describe "#update" do
    let(:work) { create(:asset) }
    let(:parameters) do
      { "asset_type" => AICType.StillImage, "pref_label" => "New Label" }
    end
    before { actor.update(parameters) }
    its(:pref_label) { is_expected.to eq("New Label") }
  end
end
