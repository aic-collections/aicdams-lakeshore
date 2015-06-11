require 'rails_helper'

describe "Editing annotations" do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  let(:category1) { "First category" }
  let(:category2) { "Second category" }

  context "using comments" do
    let(:content) { "A comment" }
    let(:comment) { Comment.create(content: content) }

    it "supports adding new categories and removing existing ones" do
      visit edit_comment_path(comment)
      expect(find_field("comment[content]").value).to eql content
      fill_in("comment[category][]", with: category1)
      click_button("upload_submit")
      expect(first(:field, "comment[category][]").value).to eql category1
      click_button("Remove")
      click_button("upload_submit")
      expect(find_field("comment[category][]").value).to be_empty
    end
  end

  context "using tags" do
    it "supports adding and removing existing categories only" do
      skip "not implemented yet"
    end
  end

end
