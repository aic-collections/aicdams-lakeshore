require 'rails_helper'

describe AssetPresenter do

  let(:presenter) { AssetPresenter.new(GenericFile.new) }

  describe "#terms" do
    subject { presenter.terms }
    it { is_expected.not_to include(:resource_type) }
  end

  describe "#brief_terms" do
    subject { presenter.brief_terms }
    it { is_expected.to contain_exactly(:relation, :asset_type, :identifier) }
  end

  describe "#asset_type" do
    context "with an image" do
      before { allow_any_instance_of(GenericFile).to receive(:is_still_image?).and_return(true) }
      subject { presenter.asset_type }
      it { is_expected.to eql("Image") }
    end
    context "with an text document" do
      before { allow_any_instance_of(GenericFile).to receive(:is_text?).and_return(true) }
      subject { presenter.asset_type }
      it { is_expected.to eql("Text Document") }
    end    
  end

end
