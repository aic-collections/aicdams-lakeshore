# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  subject { asset }

  describe "#copyright_representatives" do
    let(:representative) { create(:agent) }
    let(:asset) { create(:asset, copyright_representative_uris: [representative.uri]) }
    its(:copyright_representatives) { is_expected.to contain_exactly(representative) }
  end

  describe "#licensing_restrictions" do
    let(:restriction) { create(:list_item) }
    let(:asset) { create(:asset, licensing_restriction_uris: [restriction.uri]) }
    its(:licensing_restrictions) { is_expected.to contain_exactly(restriction) }
  end

  describe "public_domain" do
    context "by default" do
      let(:asset) { create(:asset) }
      its(:public_domain) { is_expected.to be(false) }
    end

    context "when true" do
      let(:asset) { create(:asset, public_domain: true) }
      its(:public_domain) { is_expected.to be(true) }
    end
  end
end
