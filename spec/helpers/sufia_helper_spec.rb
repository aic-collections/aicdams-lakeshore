require 'rails_helper'

describe SufiaHelper do
  describe "#url_for_document" do
    context "with a Work" do
      let(:doc) { SolrDocument.new(active_fedora_model_ssi: "Work") }
      subject { helper.url_for_document(doc) }
      it { is_expected.to eql doc }
    end
    context "with a Actor" do
      let(:doc) { SolrDocument.new(active_fedora_model_ssi: "Actor") }
      subject { helper.url_for_document(doc) }
      it { is_expected.to eql doc }
    end
    context "with any other model" do
      let(:doc) { SolrDocument.new(active_fedora_model_ssi: "Foo") }
      subject { helper.url_for_document(doc) }
      it { is_expected.to include(doc) }
    end
  end

  describe "#user_display_name_and_key" do
    context "with a group agent" do
      subject { helper.user_display_name_and_key("100") }
      it { is_expected.to eq("Department 100") }
    end
    context "with a user agent" do
      subject { helper.user_display_name_and_key("user1") }
      it { is_expected.to eq("First User") }
    end
  end
end
