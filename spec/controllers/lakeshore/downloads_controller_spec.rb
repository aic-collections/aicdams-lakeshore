# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::DownloadsController do
  let(:apiuser) { create(:apiuser) }
  let(:user)    { create(:user1) }
  let(:file)    { File.open(File.join(fixture_path, 'sun.png')) }
  let(:my_file) { create(:file_set_with_file, user: user, content: file) }

  before { sign_in_basic(apiuser) }

  describe "#show" do
    context "with a CITI thumbnail" do
      before do
        allow(controller).to receive(:citi_thumbnail).and_return(file.path)
        get :show, id: my_file.id, file: "citiThumbnail"
      end
      its(:response) { is_expected.to be_successful }
    end

    context "with an unknown file" do
      before { get :show, id: my_file.id, file: "badFile" }
      its(:status) { is_expected.to eq(404) }
    end

    context "with an unknown FileSet" do
      before { get :show, id: "xxxy", file: "citiThumbnail" }
      its(:status) { is_expected.to eq(401) }
    end
  end
end
