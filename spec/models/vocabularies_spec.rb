require 'rails_helper'

describe "Vocabulary terms" do
  describe DigitizationSource do
    before { create(:list, pref_label: "Digitization Source") }
    it_behaves_like "a vocabulary term"
  end

  describe DocumentType do
    before { create(:list, pref_label: "Document Type") }
    it_behaves_like "a vocabulary term"
  end

  describe Tag do
    before { create(:list, pref_label: "Tag") }
    it_behaves_like "a vocabulary term"
  end

  describe CommentCategory do
    before { create(:list, pref_label: "Comment Category") }
    it_behaves_like "a vocabulary term"
  end

  describe ConservationDocumentType do
    before { create(:list, pref_label: "Conservation Document Type") }
    it_behaves_like "a vocabulary term"
  end

  describe ConservationImageType do
    before { create(:list, pref_label: "Conservation Image Type") }
    it_behaves_like "a vocabulary term"
  end

  describe Compositing do
    before { create(:list, pref_label: "Compositing") }
    it_behaves_like "a vocabulary term"
  end

  describe LightType do
    before { create(:list, pref_label: "Light Type") }
    it_behaves_like "a vocabulary term"
  end

  describe View do
    before { create(:list, pref_label: "View") }
    it_behaves_like "a vocabulary term"
  end
end
