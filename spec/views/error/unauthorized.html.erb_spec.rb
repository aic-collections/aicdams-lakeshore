# frozen_string_literal: true
require 'rails_helper'

describe 'error/unauthorized.html.erb', type: :view do
  let(:presenter) { double }
  let(:page) { Capybara::Node::Simple.new(rendered) }
  before do
    stub_template 'shared/_request_access.html.erb' => ''
    allow(presenter).to receive(:title_or_label).and_return("Sample Work")
    allow(presenter).to receive(:thumbnail_path).and_return("http://path.png")
    allow(presenter).to receive(:message).and_return("You are not authorized to see this asset")
    allow(presenter).to receive(:depositor_full_name).and_return("Joe Bob")
    allow(presenter).to receive(:uid).and_return("1234")
    render template: 'error/unauthorized.html.erb', locals: { presenter: presenter }
  end

  specify do
    expect(page).to have_selector('.alert-danger', text: "You are not authorized to see this asset")
    expect(page).to have_selector('p.unauthorized_asset_display', text: "Joe Bob")
    expect(page).to have_selector('p.unauthorized_asset_display', text: "Sample Work")
    expect(page).to have_selector('p.unauthorized_asset_display', text: "1234")
    expect(page.find('img')['src']).to have_content("http://path.png")
  end
end
