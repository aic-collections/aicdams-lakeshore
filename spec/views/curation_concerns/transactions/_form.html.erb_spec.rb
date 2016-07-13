# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/transactions/_form.html.erb' do
  let(:user)    { create(:user1) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::TransactionForm.new(resource, ability) }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  context "when editing an transaction" do
    let(:resource) { create(:transaction) }
    before { render }
    it "renders fields for representations" do
      expect(page).to have_selector('input#transaction_document_uris')
      expect(page).to have_selector('input#transaction_representation_uris')
      expect(page).to have_selector('input#transaction_preferred_representation_uri')
    end
  end
end
