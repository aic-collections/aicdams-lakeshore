require 'rails_helper'

describe AttributeValueAdapter do
  subject { described_class.call(value, attribute_name) }

  context "when no value is present" do
    let(:value) { nil }
    let(:attribute_name) { "something" }
    it { is_expected.to be_nil }
  end

  context "when the id is nil" do
    let(:value) { {} }
    let(:attribute_name) { "something" }
    it { is_expected.to be_nil }
  end

  context "when there is no specified class mapping" do
    let(:value) { { "id" => "1234" } }
    let(:attribute_name) { "missing_class" }
    it { is_expected.to be_nil }
  end

  context "with a digitization_source" do
    let(:value) { { "id" => DigitizationSource.all.first.id } }
    let(:attribute_name) { "digitization_source" }
    it { is_expected.to be_kind_of(ListItem) }
  end

  context "with a document_type" do
    let(:value) { { "id" => DocumentType.all.first.id } }
    let(:attribute_name) { "document_type" }
    it { is_expected.to be_kind_of(ListItem) }
  end

  context "with a tag" do
    let(:value) { { "id" => Tag.all.first.id } }
    let(:attribute_name) { "tag" }
    it { is_expected.to be_kind_of(ListItem) }
  end

  context "with a aic_depositor" do
    let(:value) { { "id" => AICUser.all.first.id } }
    let(:attribute_name) { "aic_depositor" }
    it { is_expected.to be_kind_of(AICUser) }
  end

  context "with a dept_created" do
    let(:value) { { "id" => Department.all.first.id } }
    let(:attribute_name) { "dept_created" }
    it { is_expected.to be_kind_of(Department) }
  end
end
