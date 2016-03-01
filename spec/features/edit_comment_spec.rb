require 'rails_helper'

describe "Editing comments" do
  let(:user) { create(:user1) }
  before { sign_in_with_js user }
  let(:content) { "A comment" }
  let!(:comment) { Comment.create(content: content) }

  context "using comments" do
    let(:category1) { "First category" }
    let(:category2) { "Second category" }

    # This passes locally, but fails on Travis
    xit "supports adding new categories and removing existing ones" do
      visit edit_comment_path(comment)
      sleep(5)
      expect(find_field("comment[content]").value).to eql content
      fill_in("comment[category][]", with: category1)
      click_button("upload_submit")
      expect(first(:field, "comment[category][]").value).to eql category1
      click_button("Remove")
      click_button("upload_submit")
      expect(find_field("comment[category][]").value).to be_empty
    end
  end
end
