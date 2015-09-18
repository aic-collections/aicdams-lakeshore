require 'rails_helper'

describe Resource do

  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to eql([AICType.Resource]) }
  end

  describe "terms" do
    subject { described_class.new }
    ResourcePresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "nested assets" do
    
    let(:resource) { described_class.new }
    let(:asset) do
      GenericFile.create.tap do |file|
        file.apply_depositor_metadata "user"
      end
    end

    before do
      ResourcePresenter.assets.map { |rel| resource.send(rel.to_s + "=", [asset]) }
      resource.save
      resource.reload
    end
    specify "are types of GenericFile objects" do
      expect(resource.documents).to include(GenericFile)
      expect(resource.representations).to include(GenericFile)
      expect(resource.preferred_representations).to include(GenericFile)
    end

  end

  describe "required terms" do
    subject { described_class.create }
    specify "uid matches the id" do
      pending "Waiting on successful implementation"
      expect(subject.uid).to eql subject.id
    end
  end

  describe "cardinality" do
    [:batch_uid, :resource_created, :dept_created, :status, :resource_updated, :pref_label, :uid].each do |term|
      it "limits #{term} to a single value" do
        pending "Can't enforce singular AT resources" if [:dept_created, :status].include?(term)
        subject.send(term.to_s+"=","foo")
        expect(subject.send(term.to_s)).to eql "foo"
      end
    end
  end

end
