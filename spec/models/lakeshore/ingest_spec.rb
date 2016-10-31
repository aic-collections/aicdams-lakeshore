# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::Ingest do
  let(:user)              { create(:user1) }
  let(:controller_params) { ActionController::Parameters.new(params) }
  let(:ingest)            { described_class.new(controller_params) }

  describe "#valid?" do
    subject { ingest }

    context "when the ingest has all the required data" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "asset" },
          metadata: { document_type_uri: "doc_type", depositor: user.email }
        }
      end
      it { is_expected.to be_valid }
    end
  end

  describe "#errors" do
    before { ingest.validate }

    subject { ingest.errors }

    context "without the required parameters" do
      let(:params) { { asset_type: "StillImage" } }
      its(:full_messages) { is_expected.to contain_exactly("Ingestor can't be blank",
                                                           "Document type uri can't be blank",
                                                           "Intermediate file can't be blank") }
    end

    context "with a bad asset type" do
      let(:params) { { asset_type: "BadType" } }
      its(:full_messages) { is_expected.to include("Asset type BadType is not a registered asset type") }
    end
  end

  describe "#files" do
    let(:params) do
      {
        asset_type: "StillImage",
        content: content,
        metadata: { document_type_uri: "doc_type", depositor: user.email }
      }
    end

    subject do
      described_class.new(controller_params).files.map do |id|
        Sufia::UploadedFile.find(id).use_uri
      end
    end

    context "with only an intermediate file" do
      let(:content) { { intermediate: "intermediate asset" } }
      it { is_expected.to contain_exactly(AICType.IntermediateFileSet) }
    end

    context "with original, intermediate, and preservation files" do
      let(:content) do
        { original: "original asset", pres_master: "preservation master asset", intermediate: "intermediate asset" }
      end
      it { is_expected.to contain_exactly(AICType.OriginalFileSet,
                                          AICType.IntermediateFileSet,
                                          AICType.PreservationMasterFileSet) }
    end

    context "with assorted other files" do
      let(:content) do
        { "intermediate" => "intermediate asset", "0" => "oddball 0", "1" => "oddball 1", "other" => "other" }
      end

      it { is_expected.to contain_exactly(AICType.IntermediateFileSet, nil, nil, nil) }
    end
  end
end
