require 'rails_helper'

describe '_user_util_links.html.erb' do
  before do
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    stub_template 'users/_notify_link.html.erb' => ''
    render
  end

  context "with an admin user" do
    let(:user) { create(:admin) }
    it "displays admin links" do
      expect(rendered).to have_link("resque admin")
    end
  end

  context "with a standard user" do
    let(:user) { create(:user1) }
    it "displays a logout link" do
      expect(rendered).to have_link("logout", href: '/Shibboleth.sso/Logout')
    end
  end
end
