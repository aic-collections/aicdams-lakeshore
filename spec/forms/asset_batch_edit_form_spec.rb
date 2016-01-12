require 'rails_helper'

describe AssetBatchEditForm do
  describe "::terms" do
    subject { described_class.terms }
    it { is_expected.not_to include(:pref_label) }
  end

  describe ".model_attributes" do
    let(:params) do
      ActionController::Parameters.new(document_type_ids: DocumentType.all.map(&:id),
                                       representation_for: "xxxx",
                                       document_for:  "yyyyy")
    end
    subject { described_class.model_attributes(params).keys }

    it { is_expected.to contain_exactly("representation_for", "document_for", "document_type_ids") }
  end
end
