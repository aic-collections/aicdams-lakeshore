# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::DerivativesController do
  let(:apiuser)  { create(:apiuser) }
  let(:user2)    { create(:user2) }
  let(:file)     { File.open(File.join(fixture_path, 'sun.png')) }
  let(:file_set) { asset.intermediate_file_set.first }

  before { sign_in_basic(apiuser) }

  describe "#show" do
    # TODO: You shouldn't need these, but we're having 401 errors when this test
    # is run in the suite. Could be leftover authentication bits from a previous test.
    before do
      allow(controller).to receive(:check_authorization)
      allow(controller).to receive(:clear_session_user)
    end

    subject { response }

    context "with an existing file set" do
      let(:asset) { create(:asset, :with_intermediate_file_set) }

      before do
        allow(DerivativePath).to receive(:access_path).with(file_set.id).and_return(file.path)
        get :show, id: asset.id, file: "access_master"
      end

      it { is_expected.to be_successful }
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
