require 'rails_helper'

describe Work do

  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Work, AICType.Resource) }
  end

  describe "metadata" do
    subject { described_class.new }
    context "defined in the presenter" do
      WorkPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "#assets" do
    let(:asset) do
      GenericFile.create.tap do |f|
        f.title = ["Asset in a work"]
        f.apply_depositor_metadata "user"
        f.save
      end
    end
    let(:work) do
      Work.create.tap do |w|
        w.asset_ids = [asset.id]
        w.save
      end
    end
    specify { expect(work.assets).to include(asset) }
    context "when removing the asset from the work" do
      before { work.asset_ids = [] }
      it "retains the asset" do
        expect(work.assets).to be_empty
        expect(GenericFile.all).to include(asset)
      end
    end
    context "when deleting the asset" do
      before { asset.destroy }
      it "removes the asset from the work" do
        pending
        expect(work.assets).to be_empty
      end
    end
  end

  describe "cardinality" do
    subject { described_class.new }
    context "of AIC.publVerLevel" do
      it "disallows multiple values" do
        expect(lambda { subject.publ_ver_level = ["multivalue"] }).to raise_error(ArgumentError)
      end
    end
  end

  describe "terms writable during creation only" do
    let(:wro_single_terms) { [:batch_uid, :aiccreated, :department] }
    let(:error_message) { "is writable only on create"}
    let(:first_value) { "write-once value" }
    subject do
      Work.new.tap do |file|
        file.batch_uid  = first_value
        file.aiccreated = first_value
        file.department = first_value
        file.legacy_uid = [first_value] 
        file.save
      end
    end
    specify "are not updateable" do
      wro_single_terms.each do |term|
        expect(subject.send(term)).to eql first_value
        subject.send(term.to_s+"=", "a changed value")
        expect(subject.save).to be false
        expect(subject.errors[term]).to eql([error_message])
      end
      expect(subject.legacy_uid).to eql [first_value]
      subject.legacy_uid = ["more","values"]
      expect(subject.save).to be false
      expect(subject.errors[:legacy_uid]).to eql([error_message])  
    end
  end

  describe "required terms" do
    subject do
      Work.create.tap do |file|
        file.save!
      end
    end
    it { is_expected.to be_kind_of Work }
    specify "uid matches the id" do
      expect(subject.uid).to eql subject.id
    end
  end  

  describe "#to_solr" do
    subject { described_class.new.to_solr }
    it "has default public read access" do
      expect(subject["read_access_group_ssim"]).to include("public")
    end
    it "has an AIC type" do
      expect(subject["aic_type_sim"]).to include("Work")
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "open" }
  end

  describe "permissions" do
    subject { described_class.new } 
    it { is_expected.to be_public }
    it { is_expected.not_to be_registered }
  end

end
