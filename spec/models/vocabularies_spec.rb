require 'rails_helper'

describe "Vocabulary terms" do
  describe DigitizationSource do
    it_behaves_like "a vocabulary term", "Sample Digitization Source List Item"
  end

  describe DocumentType do
    it_behaves_like "a vocabulary term", "Sample Document Type List Item"
  end

  describe Tag do
    it_behaves_like "a vocabulary term", "Sample Tag List Item"
  end

  describe CommentCategory do
    it_behaves_like "a vocabulary term", "Sample Comment Category List Item"
  end

  describe ConservationDocumentType do
    it_behaves_like "a vocabulary term", "Sample Conservation Document Type List Item"
  end

  describe ConservationImageType do
    it_behaves_like "a vocabulary term", "Sample Conservation Image Type List Item"
  end

  describe Compositing do
    it_behaves_like "a vocabulary term", "Sample Compositing List Item"
  end

  describe LightType do
    it_behaves_like "a vocabulary term", "Sample Light Type List Item"
  end

  describe View do
    it_behaves_like "a vocabulary term", "Sample View List Item"
  end
end
