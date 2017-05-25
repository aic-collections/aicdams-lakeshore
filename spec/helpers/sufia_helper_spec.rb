# frozen_string_literal: true
require 'rails_helper'

describe SufiaHelper do
  describe "#visibility_options" do
    subject { helper.visibility_options(option) }
    context "with looser restrictions" do
      let(:option) { :loosen }
      it { is_expected.to eq([["Open Access", "open"], ["AIC", "authenticated"]]) }
    end

    context "with tighter restrictions" do
      let(:option) { :restrict }
      it { is_expected.to eq([["Department", "department"], ["AIC", "authenticated"]]) }
    end
  end

  describe "#user_display_name_and_key" do
    context "with a group agent" do
      subject { helper.user_display_name_and_key("100") }
      it { is_expected.to eq("Department 100") }
    end
    context "with a user agent" do
      subject { helper.user_display_name_and_key("user1") }
      it { is_expected.to eq("First User (user1)") }
    end
  end

  describe "#on_my_works?" do
    subject { helper.on_my_works? }

    context "when on my assets" do
      before { controller.params[:controller] = "my/works" }
      it { is_expected.to be_truthy }
    end

    context "when on assets shared with me" do
      before { controller.params[:controller] = "my/shared" }
      it { is_expected.to be_truthy }
    end

    context "when on my collections" do
      before { controller.params[:controller] = "my/collections" }
      it { is_expected.to be_falsey }
    end
  end
end
