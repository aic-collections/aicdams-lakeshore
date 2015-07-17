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

end
