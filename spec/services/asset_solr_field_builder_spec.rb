# frozen_string_literal: true
require 'rails_helper'

describe AssetSolrFieldBuilder do
  let(:asset) { build(:still_image_asset) }

  subject { described_class.new(asset) }

  context "with no relationships" do
    let(:mock_relationships) do
      instance_double("InboundAssetReference", attachments: [])
    end

    before do
      allow(subject).to receive(:relationships).and_return(mock_relationships)
    end

    its(:attachment_facet)               { is_expected.to be_nil }
    its(:has_attachment_facet)           { is_expected.to be_nil }
    its(:has_attachment_ids)             { is_expected.to be_empty }
    its(:documentation_facet)            { is_expected.to be_nil }
    its(:representation_facet)           { is_expected.to be_nil }
    its(:preferred_representation_facet) { is_expected.to be_nil }
    its(:related_works)                  { is_expected.to include_json([]) }
    its(:main_ref_numbers)               { is_expected.to be_empty }
  end

  context "with relationships" do
    let(:mock_relationships) do
      instance_double("InboundAssetReference", attachments: ["attachment"])
    end

    before do
      allow(subject).to receive(:relationships).and_return(mock_relationships)
      allow(asset).to receive(:attachment_of).and_return(["attachment"])
      allow(asset).to receive(:document_of).and_return(["document"])
      allow(asset).to receive(:representation_of).and_return(["representation"])
      allow(asset).to receive(:preferred_representation_of).and_return(["preferred_representation"])
    end

    its(:attachment_facet)               { is_expected.to eq("Is Attachment") }
    its(:has_attachment_facet)           { is_expected.to eq("Has Attachment") }
    its(:documentation_facet)            { is_expected.to eq("Documentation For") }
    its(:representation_facet)           { is_expected.to eq("Is Representation") }
    its(:preferred_representation_facet) { is_expected.to eq("Is Preferred Representation") }
  end

  describe "related_works" do
    context "with missing work data" do
      let(:representations) { Array.wrap(build(:work, :with_sample_metadata, citi_uid: "", main_ref_number: "")) }

      before { allow(asset).to receive(:representation_of).and_return(representations) }

      its(:related_works) { is_expected.to include_json([]) }
      its(:main_ref_numbers) { is_expected.to be_empty }
    end

    context "with one relationship" do
      let(:representations) { Array.wrap(build(:work, :with_sample_metadata)) }

      before { allow(asset).to receive(:representation_of).and_return(representations) }

      its(:related_works) { is_expected.to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("1999.397") }
    end

    context "with two relationships" do
      let(:representations) do
        [
          build(:work, :with_sample_metadata),
          build(:work, :with_sample_metadata, citi_uid: "12345", main_ref_number: "2017.392")
        ]
      end

      before { allow(asset).to receive(:representation_of).and_return(representations) }

      its(:related_works) { is_expected.to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" },
                                                         { citi_uid: "12345", main_ref_number: "2017.392" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("1999.397", "2017.392") }
    end

    context "with a preferred representation" do
      let(:preferred_representations) { Array.wrap(build(:work, citi_uid: "12345", main_ref_number: "2017.392")) }

      before { allow(asset).to receive(:representation_of).and_return(preferred_representations) }

      its(:related_works) { is_expected.to include_json([{ citi_uid: "12345", main_ref_number: "2017.392" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("2017.392") }
    end

    context "with several preferred representations" do
      let(:preferred_representations) do
        [
          build(:work, citi_uid: "54321", main_ref_number: "1720.392"),
          build(:work, citi_uid: "12345", main_ref_number: "2017.392")
        ]
      end

      before { allow(asset).to receive(:representation_of).and_return(preferred_representations) }

      its(:related_works) { is_expected.to include_json([{ citi_uid: "54321", main_ref_number: "1720.392" },
                                                         { citi_uid: "12345", main_ref_number: "2017.392" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("1720.392", "2017.392") }
    end
  end
end
