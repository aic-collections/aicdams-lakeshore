# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::DownloadsController do
  let(:apiuser) { create(:apiuser) }
  let(:user)    { create(:user1) }
  let(:file)    { File.open(File.join(fixture_path, 'sun.png')) }
  let(:my_file) { create(:file_set_with_file, user: user, content: file) }

  before { sign_in_basic(apiuser) }

  describe "#show" do
    before { allow(controller).to receive(:citi_thumbnail).and_return(file.path) }

    context "with a CITI thumbnail" do
      before { get :show, id: my_file.id, file: "citiThumbnail" }
      its(:response) { is_expected.to be_successful }
    end

    context "with an unknown file" do
      before { get :show, id: my_file.id, file: "badFile" }
      its(:response) { is_expected.to be_not_found }
    end

    context "with an unknown FileSet" do
      before { get :show, id: "xxxy", file: "citiThumbnail" }
      its(:response) { is_expected.to be_unauthorized }
    end

    context "on behalf of another user who has access" do
      before { get :show, id: my_file.id, file: "citiThumbnail", on_behalf_of: "user1" }
      its(:response) { is_expected.to be_successful }
    end

    context "on behalf of another user who does not have access" do
      before do
        create(:user2)
        get :show, id: my_file.id, file: "citiThumbnail", on_behalf_of: "user2"
      end
      its(:response) { is_expected.to be_unauthorized }
    end

    context "on behalf of a bogus user" do
      before { get :show, id: my_file.id, file: "citiThumbnail", on_behalf_of: "asdf" }
      its(:response) { is_expected.to be_unauthorized }
    end
  end
end
