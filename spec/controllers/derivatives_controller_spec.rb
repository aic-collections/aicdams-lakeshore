# frozen_string_literal: true
require 'rails_helper'

describe DerivativesController do
  include_context "authenticated saml user"
  let(:user2)    { create(:user2) }
  let(:file)     { File.open(File.join(fixture_path, 'sun.png')) }
  let(:file_set) { asset.intermediate_file_set.first }

  describe "#show" do
    subject { response }

    context "with an existing file set" do
      before do
        allow(DerivativePath).to receive(:access_path).with(file_set.id).and_return(file.path)
        get :show, id: asset.id, file: "access_master"
      end

      context "when the asset is viewable" do
        let(:asset) { create(:asset, :with_intermediate_file_set) }
        it { is_expected.to be_successful }
      end

      context "when the asset is not viewable" do
        let(:asset) { create(:asset, :with_intermediate_file_set, user: user2) }
        it { is_expected.to be_redirect }
      end
    end

    context "with a non-existent file set" do
      let(:asset) { create(:asset) }

      before { get :show, id: asset.id, file: "access_master" }

      it { is_expected.to be_not_found }
    end

    context "with a non-existent derivative type" do
      let(:asset) { create(:asset, :with_intermediate_file_set) }

      before do
        allow(DerivativePath).to receive(:access_path).with(file_set.id).and_return(file.path)
        get :show, id: asset.id, file: :foo
      end

      it { is_expected.to be_not_found }
    end
  end
end
