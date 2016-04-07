require 'rails_helper'

describe "Vocabulary terms" do
  describe DigitizationSource do
    let!(:vocab) { create(:list, pref_label: "Digitization Source") }
    it_behaves_like "a vocabulary term"
  end

  describe DocumentType do
    let!(:vocab) { create(:list, pref_label: "Document Type") }
    it_behaves_like "a vocabulary term"
  end

  describe Tag do
    let!(:vocab) { create(:list, pref_label: "Tag") }
    it_behaves_like "a vocabulary term"
  end

  describe CommentCategory do
    let!(:vocab) { create(:list, pref_label: "Comment Category") }
    it_behaves_like "a vocabulary term"
  end

  describe ConservationDocumentType do
    let!(:vocab) { create(:list, pref_label: "Conservation Document Type") }
    it_behaves_like "a vocabulary term"
  end

  describe ConservationImageType do
    let!(:vocab) { create(:list, pref_label: "Conservation Image Type") }
    it_behaves_like "a vocabulary term"
  end

  describe Compositing do
    let!(:vocab) { create(:list, pref_label: "Compositing") }
    it_behaves_like "a vocabulary term"
  end

  describe LightType do
    let!(:vocab) { create(:list, pref_label: "Light Type") }
    it_behaves_like "a vocabulary term"
  end

  describe View do
    let!(:vocab) { create(:list, pref_label: "View") }
    it_behaves_like "a vocabulary term"
  end

  describe Status do
    describe "#options" do
      subject { described_class.options }
      its(:keys) { is_expected.to contain_exactly("Active") }
    end
    describe "#members" do
      subject { described_class.all }
      its(:first) { is_expected.to be_kind_of(StatusType) }
    end
  end
end
