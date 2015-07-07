require 'rails_helper'

describe Work do

  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Work, AICType.Resource) }
  end

  describe "metadata" do
    subject { described_class.new }
    it { is_expected.to respond_to(:assets) }
    it { is_expected.to respond_to(:after) }
    it { is_expected.to respond_to(:artist_display) }
    it { is_expected.to respond_to(:artist_uid) }
    it { is_expected.to respond_to(:before) }
    it { is_expected.to respond_to(:coll_cat_uid) }
    it { is_expected.to respond_to(:credit_line) }
    it { is_expected.to respond_to(:dept_uid) }
    it { is_expected.to respond_to(:dimensions_display) }
    it { is_expected.to respond_to(:exhibition_history) }
    it { is_expected.to respond_to(:gallery_location) }
    it { is_expected.to respond_to(:inscriptions) }
    it { is_expected.to respond_to(:main_ref_number) }
    it { is_expected.to respond_to(:medium_display) }
    it { is_expected.to respond_to(:object_type) }
    it { is_expected.to respond_to(:place_of_origin) }
    it { is_expected.to respond_to(:provenance_text) }
    it { is_expected.to respond_to(:publication_history) }
    it { is_expected.to respond_to(:publ_tag) }
    it { is_expected.to respond_to(:publ_ver_level) }
  end

  describe "related works" do
    let(:asset) do
      GenericFile.create.tap do |f|
        f.title = ["Asset in a work"]
        f.apply_depositor_metadata "user"
        f.save
      end
    end
    let(:work) { Work.create }
    subject do
      work.asset_ids = [asset.id]
      work.save
      work
    end
    specify { expect(subject.assets).to include(asset) }
  end

  describe "cardinality" do
    subject { described_class.new }
    context "of AIC.publVerLevel" do
      it "disallows multiple values" do
        expect(lambda { subject.publ_ver_level = ["multivalue"] }).to raise_error(ArgumentError)
      end
    end
  end

end
