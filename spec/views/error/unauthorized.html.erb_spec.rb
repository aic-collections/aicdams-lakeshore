# frozen_string_literal: true
require 'rails_helper'

describe 'error/unauthorized.html.erb', type: :view do
  let(:presenter) { double }
  let(:page) { Capybara::Node::Simple.new(rendered) }
  before do
    allow(presenter).to receive(:title).and_return("Sample Work")
    allow(presenter).to receive(:thumbnail).and_return("http://path.png")
    allow(presenter).to receive(:message).and_return("You are not authorized to see this asset")
    allow(presenter).to receive(:depositor).and_return("Joe Bob")
    render template: 'error/unauthorized.html.erb', locals: { presenter: presenter }
  end

  specify do
    expect(page).to have_selector('.alert-danger', text: "You are not authorized to see this asset")
  end
end
