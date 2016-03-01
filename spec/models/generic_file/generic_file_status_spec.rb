require 'rails_helper'

describe "GenericFile" do
  let(:example_file) { create(:asset) }

  subject { example_file }

  describe "#status" do
    context "by default" do
      it { is_expected.to be_active }
    end

    context "invalid" do
      before { example_file.status = StatusType.invalid }
      it { is_expected.to be_invalid }
    end

    context "disabled" do
      before { example_file.status = StatusType.disabled }
      it { is_expected.to be_disabled }
    end

    context "deleted" do
      before { example_file.status = StatusType.deleted }
      it { is_expected.to be_deleted }
    end

    context "archived" do
      before { example_file.status = StatusType.archived }
      it { is_expected.to be_archived }
    end
  end

  describe "loading from solr" do
    subject { ActiveFedora::Base.load_instance_from_solr(example_file.id) }
    it { is_expected.to be_active }
  end

  describe "#status_id" do
    before do
      example_file.status_id = StatusType.deleted.id
      example_file.save
      example_file.reload
    end
    it { is_expected.to be_deleted }
  end
end
