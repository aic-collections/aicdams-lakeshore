# frozen_string_literal: true
require 'rails_helper'

RSpec.describe IIIFAuthorizationService do
  let(:ability) { Ability.new(user) }
  let(:controller) { double(current_ability: ability) }
  let(:file_set) { create(:file_set) }
  let(:service) { described_class.new(controller) }
  let(:file_set_id) { file_set.id }
  let(:image_id) { "#{file_set_id}/files/0b957460-99b4-4c31-902f-0fc23eefb972" }
  let(:image) { Riiif::Image.new(image_id) }

  describe "#can?" do
    context "when the user has read access to the FileSet" do
      let(:user) { create(:default_user) }
      context "info" do
        subject { service.can?(:info, image) }
        it { is_expected.to be true }
      end

      context "show" do
        subject { service.can?(:show, image) }
        it { is_expected.to be true }
      end
    end

    context "when the user doesn't have read access to the FileSet" do
      let(:user) { create(:different_user) }
      context "info" do
        subject { service.can?(:info, image) }
        it { is_expected.to be false }
      end

      context "show" do
        subject { service.can?(:show, image) }
        it { is_expected.to be false }
      end
    end
  end
end
