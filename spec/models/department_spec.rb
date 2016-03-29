require 'rails_helper'

describe Department do
  describe "#citi_uid" do
    subject { described_class.all.map(&:citi_uid) }
    it { is_expected.to contain_exactly("100", "200") }
  end

  describe "::options" do
    subject { described_class.options }
    its(:values) { is_expected.to contain_exactly("100", "200") }
  end

  describe "::find_by_department_key" do
    context "with results" do
      subject { described_class.find_by_department_key("200") }
      its(:pref_label) { is_expected.to eq("Department 200") }
    end
    context "with no results" do
      subject { described_class.find_by_department_key("201") }
      it { is_expected.to be_nil }
    end
  end

  describe "::find_by_citi_uid" do
    context "with results" do
      subject { described_class.find_by_citi_uid("200") }
      its(:pref_label) { is_expected.to eq("Department 200") }
    end
    context "with no results" do
      subject { described_class.find_by_department_key("201") }
      it { is_expected.to be_nil }
    end
  end
end
