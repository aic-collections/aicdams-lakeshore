# frozen_string_literal: true
require 'rails_helper'

describe "lists/index.html.erb" do
  let(:user2_list) { create(:list) }
  let(:private_list) { create(:private_list) }
  let(:lists) { [ListPresenter.new(user2_list), ListPresenter.new(private_list)] }
  subject { render }

  before { assign(:lists, lists) }

  context "with an admin user" do
    before { allow(controller).to receive(:current_user).and_return(build(:admin)) }
    xit { is_expected.to have_link("Modify items", count: lists.count) }
    xit { is_expected.to have_link("Edit permissions", count: lists.count) }
  end

  context "with a user who has no edit rights" do
    before { allow(controller).to receive(:current_user).and_return(build(:user1)) }
    xit { is_expected.not_to have_link("Modify items") }
    xit { is_expected.not_to have_link("Edit permissions") }
  end

  context "with a user who can edit a list" do
    before { allow(controller).to receive(:current_user).and_return(build(:user2)) }
    xit { is_expected.to have_link("Modify items", count: 1) }
    xit { is_expected.not_to have_link("Edit permissions") }
  end
end
