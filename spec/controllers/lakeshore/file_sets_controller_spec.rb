# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::FileSetsController do
  let(:apiuser) { create(:apiuser) }
  before do
    sign_in_basic(apiuser)
    LakeshoreTesting.restore
  end

  let(:asset)     { create(:asset, :with_intermediate_file_set) }
  let(:file_set1) { asset.intermediate_file_set.first }
  let(:file)      { create(:image_file) }
  let(:aic_user1) { create(:aic_user1) }

  describe "#update" do
    before { put :update, params }
    context "when API user exists" do
      context "but is not an AICUser and no depositor param exists" do
        let(:file_set_params) { { files: [file] } }
        let(:params)          { { file_set: file_set_params, id: file_set1.id } }
        it "returns a 400 respone code with an error message" do
          expect(response).to have_http_status(400)
          expect(response.body).to include("AICUser '' not found, please review the depositor.\n")
        end
      end

      context "but is not an AICUser and depositor is not an AICUser" do
        let(:file_set_params) { { files: [file] } }
        let(:params)          { { file_set: file_set_params, id: file_set1.id, depositor: "derp" } }
        it "returns a 400 respone code with an error message" do
          expect(response).to have_http_status(400)
          expect(response.body).to include("AICUser 'derp' not found, please review the depositor.\n")
        end
      end

      context "and valid despositor is passed in" do
        let(:file_set_params) { { files: [file] } }
        let(:params)          { { file_set: file_set_params, id: file_set1.id, depositor: aic_user1.nick } }
        it "does not return a 400" do
          expect(response).not_to have_http_status(400)
        end
      end
    end
  end
end
