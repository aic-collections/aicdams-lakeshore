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

end
