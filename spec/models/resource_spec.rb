require 'rails_helper'

describe Resource do

  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to eql([AICType.Resource]) }
  end

  describe "terms" do
    subject { described_class.new }
    ResourceTerms.all.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "nested resources" do    
    let(:resource) { described_class.new }

    context "with other assets" do
      let(:asset) do
        GenericFile.create.tap do |file|
          file.apply_depositor_metadata "user"
          file.assert_still_image
          file.save
        end
      end
      
      before do
        ResourceTerms.related_asset_ids.map { |rel| resource.send(rel.to_s + "=", [asset.id]) }
        resource.save
        resource.reload
      end
      
      specify "are types of GenericFile objects" do
        expect(resource.documents).to include(GenericFile)
        expect(resource.representations).to include(GenericFile)
        expect(resource.preferred_representations).to include(GenericFile)
      end
    end

    context "with a MetadataSet" do
      let(:metadata) do
        MetadataSet.create.tap do |set|
          set.save
        end
      end

      before do
        resource.described_by = [metadata]
        resource.save
        resource.reload
      end
 
      subject { resource.described_by }
      it { is_expected.to include(MetadataSet) }
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
    # TODO: Add :status once CITI resources are loading the correct active StatusType, see #127
    [:batch_uid, :resource_created, :dept_created, :resource_updated, :pref_label, :uid, :icon].each do |term|
      it "limits #{term} to a single value" do
        pending "Can't enforce singular AT resources" if term == :dept_created
        subject.send(term.to_s+"=","foo")
        expect(subject.send(term.to_s)).to eql "foo"
      end
    end
  end

end
