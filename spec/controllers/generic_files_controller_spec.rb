require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  describe "#create" do
    let(:mock) { GenericFile.new }
    let(:batch) { Batch.create }
    let(:batch_id) { batch.id }
    let(:file) { fixture_file_upload('/sun.png') }
    let(:json_response) { JSON.parse(response.body) }

    before { allow(GenericFile).to receive(:new).and_return(mock) }

    context "without an asset type" do
      before { xhr :post, :create, files: [file], Filename: 'The sun', batch_id: batch_id, terms_of_service: '1' }
      it "returns an error" do
        expect(response).to be_success
        expect(json_response.first["error"]).to eq("You must provide an asset type")
      end
    end

    context "with an incorrect asset type" do
      before { xhr :post, :create, files: [file], Filename: 'The sun', batch_id: batch_id, terms_of_service: '1', asset_type: "asdf" }
      it "returns an error" do
        expect(response).to be_success
        expect(json_response.first["error"]).to eq("Asset type must be either still_image or text")
      end
    end

    context "with a StillImage type" do
      let(:generic_file) { Batch.find(response.request.params["batch_id"]).generic_files.first }
      it "sets the asset type to StillImage" do
        file = fixture_file_upload('/sun.png')
        xhr :post, :create, files: [file], Filename: 'The sun', batch_id: batch_id, terms_of_service: '1', asset_type: 'still_image'
        expect(response).to be_success
        expect(generic_file.type).to include AICType.StillImage
      end
    end

    context "with a Text type" do
      let(:generic_file) { Batch.find(response.request.params["batch_id"]).generic_files.first }
      it "sets the asset type to Text" do
        file = fixture_file_upload('/text.txt')
        xhr :post, :create, files: [file], Filename: 'Sample text file', batch_id: batch_id, terms_of_service: '1', asset_type: 'text'
        expect(response).to be_success
        expect(generic_file.type).to include AICType.Text
      end
    end

    context "with an incorrect StillImage mime type" do
      it "returns an error" do
        file = fixture_file_upload('/text.txt')
        xhr :post, :create, files: [file], Filename: 'An incorrect image file', batch_id: batch_id, terms_of_service: '1', asset_type: 'still_image'
        expect(response).to be_success
        expect(json_response.first["error"]).to eq("Submitted file does not have a mime type for a still image")
      end
    end

    context "with an incorrect Text mime type" do
      it "returns an error" do
        file = fixture_file_upload('/fake_photoshop.psd')
        xhr :post, :create, files: [file], Filename: 'An incorrect text file', batch_id: batch_id, terms_of_service: '1', asset_type: 'text'
        expect(response).to be_success
        expect(json_response.first["error"]).to eq("Submitted file does not have a mime type for a text file")
      end
    end

    context "with an unknown mime type" do
      it "returns an error" do
        file = fixture_file_upload('/fake_file.xzy')
        xhr :post, :create, files: [file], Filename: 'File with an unknown mime type', batch_id: batch_id, terms_of_service: '1', asset_type: 'text'
        expect(response).to be_success
        expect(json_response.first["error"]).to eq("Submitted file is an unknown mime type")
      end
    end
  end

  describe "#update" do
    subject { flash[:error] }
    context "when uploading a text file to a still image" do
      let(:image_asset) do
        GenericFile.create do |gf|
          gf.apply_depositor_metadata(user)
          gf.assert_still_image
        end
      end
      before { post :update, id: image_asset, filedata: fixture_file_upload('/text.txt') }
      it { is_expected.to include("New version's mime type does not match existing type") }
    end

    context "when uploading a still image to a text file" do
      let(:text_asset) do
        GenericFile.create do |gf|
          gf.apply_depositor_metadata(user)
          gf.assert_text
        end
      end
      before { post :update, id: text_asset, filedata: fixture_file_upload('/fake_photoshop.psd') }
      it { is_expected.to include("New version's mime type does not match existing type") }
    end
  end

  describe "#index" do
    routes { Lakeshore::Application.routes }
    before { get :index }
    subject { response }
    it { is_expected.to redirect_to("http://test.host/catalog?f%5Baic_type_sim%5D%5B%5D=Asset") }
  end
end
