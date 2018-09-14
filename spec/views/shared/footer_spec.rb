# frozen_string_literal: true
require 'rails_helper'

describe "shared/_footer.html.erb" do
  describe "git-info" do
    let(:string) { "git-info" }
    before do
      allow(view).to receive(:current_user).and_return(user)
    end
    context "when admin signed in" do
      let(:user) { create(:admin) }
      it "is viewable" do
        render
        expect(rendered).to match string
      end
    end
    context "when non-admin signed in" do
      let(:user) { create(:user) }
      it "is not viewable" do
        render
        expect(rendered).not_to match string
      end
    end
  end
end
