require 'rails_helper'

describe "Editing annotations" do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  let(:category1) { "First category" }
  let(:category2) { "Second category" }

  context "using comments" do
    let(:content) { "A comment" }
    let(:comment) { Comment.create(content: content) }

    it "supports adding and removing categories" do
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
    let(:content) { "A tag" }
    let(:tag) { Tag.create(content: content) }

    it "supports adding and removing categories" do
      visit edit_tag_path(tag)
      expect(find_field("tag[content]").value).to eql content
      fill_in("tag[category][]", with: category1)
      click_button("upload_submit")
      expect(first(:field, "tag[category][]").value).to eql category1
      click_button("Remove")
      click_button("upload_submit")
      expect(find_field("tag[category][]").value).to be_empty
    end
  end

end
