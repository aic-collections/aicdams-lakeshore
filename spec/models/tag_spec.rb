require 'rails_helper'

describe Tag do

  let(:content)    { "tag content"}
  let(:pref_label) { "pref label"}
  let(:tag)        { Tag.create(content: content) }

  let(:tagcat1) do
    TagCat.create.tap do |t|
      t.pref_label = pref_label
      t.apply_depositor_metadata("user")
      t.save
    end
  end 
  
  describe "#content" do
    subject { tag.content }
    it { is_expected.to eql content }
  end

  describe "#type" do
    subject { tag.type }
    it { is_expected.to include(AICType.Tag, AICType.Annotation, AICType.Resource) }
  end

  describe "#tagcats" do
    before { tag.tagcat_ids = [tagcat1.id] }
    subject { tag.tagcats.first.pref_label }
    it { is_expected.to eql pref_label }
    context "after updating" do
      let(:updated_label) { "updated label"}
      before do
        tag.tagcats_attributes = [{id: tagcat1.id, pref_label: updated_label }]
        tag.save
      end
      it { is_expected.to eql updated_label }
    end
  end

  describe "#destroy" do
    subject do
      tag.save
      tag
    end
    it "deletes the resource" do
      expect(subject.destroy).to be_kind_of(Tag)
    end
  end

end
