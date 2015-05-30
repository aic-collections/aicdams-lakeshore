require 'rails_helper'

describe TagCat do

  let(:category) { TagCat.new }
  let(:pref_label) { "the category's content" }
  let(:user) { "user" }

  it "is a kind of AICType.TagCat" do
    expect(category.type).to include(AICType.TagCat)
  end

  context "when definng the tag's content" do
    before do
      category.pref_label = pref_label
      category.apply_depositor_metadata user
      category.save
    end
    subject { category.pref_label }
    it { is_expected.to eql pref_label }
  end

  context "when added to a Tag" do
    let(:tag) { Tag.create(content: "the tag's content") }
    before do
      category.pref_label = pref_label
      category.apply_depositor_metadata user
      tag.tagcats = [category]
    end
    it "is a set of resources" do
      expect(tag.tagcats.first.pref_label).to eql pref_label
    end
    it "references its parent" do
      expect(category.aictags).to include(tag)
    end
  end

  describe "access controls" do
    let(:permissions_attributes) do
      [
        {type: 'person', access: 'read', name: "person1"},
        {type: 'person', access: 'read', name: "person2"},
        {type: 'group', access: 'read', name: "group-6"},
        {type: 'group', access: 'read', name: "group-7"},
        {type: 'group', access: 'edit', name: "group-8"}
      ]
    end

    subject do
      category.apply_depositor_metadata user
      category.permissions_attributes = permissions_attributes
      category
    end

    it "should have read groups accessor" do
      expect(subject.read_groups).to eq ['group-6', 'group-7']
    end

    it "should have read groups string accessor" do
      expect(subject.read_groups_string).to eq 'group-6, group-7'
    end

    it "should have read groups writer" do
      subject.read_groups = ['group-2', 'group-3']
      expect(subject.read_groups).to eq ['group-2', 'group-3']
    end

    it "should have read groups string writer" do
      subject.read_groups_string = 'umg/up.dlt.staff, group-3'
      expect(subject.read_groups).to eq ['umg/up.dlt.staff', 'group-3']
      expect(subject.edit_groups).to eq ['group-8']
      expect(subject.read_users).to eq ['person1', 'person2']
      expect(subject.edit_users).to eq [user]
    end

    it "should only revoke eligible groups" do
      subject.set_read_groups(['group-2', 'group-3'], ['group-6'])
      # 'group-7' is not eligible to be revoked
      expect(subject.read_groups).to match_array ['group-2', 'group-3', 'group-7']
      expect(subject.edit_groups).to eq ['group-8']
      expect(subject.read_users).to match_array ['person1', 'person2']
      expect(subject.edit_users).to eq [user]
    end
  end

  describe "permissions validation" do
    subject do
      category.apply_depositor_metadata user
      category
    end

    context "when the depositor does not have edit access" do
      before { subject.permissions = [ Hydra::AccessControls::Permission.new(type: 'person', name: 'mjg36', access: 'read')] }
      it "should be invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:edit_users]).to include('Depositor must have edit access')
      end
    end

    context "when the public has edit access" do
      before { subject.edit_groups = ['public'] }

      it "should be invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:edit_groups]).to include('Public cannot have edit access')
      end
    end

    context "when registered has edit access" do
      before { subject.edit_groups = ['registered'] }

      it "should be invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:edit_groups]).to include('Registered cannot have edit access')
      end
    end

    context "everything is copacetic" do
      it { is_expected.to be_valid }
    end
  end

end
