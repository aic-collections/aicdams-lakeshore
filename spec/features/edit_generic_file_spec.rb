require 'rails_helper'

describe "Editing generic files" do

  let(:user) { FactoryGirl.create(:user) }
  let(:title) { "Sample file to edit" }
  let(:file) do
    GenericFile.new.tap do |f|
      f.title = [title]
      f.apply_depositor_metadata(user.user_key)
      f.save!
    end
  end

  before { sign_in user }

  context "with comments" do
    let(:comment0) { "The first comment"  }
    let(:comment1) { "The second comment" }
    let(:comment2) { "The third comment"  }

    it "supports adding and removing" do
      visit sufia.edit_generic_file_path(file)
      expect(page).to have_content("Edit #{title}")
      expect(page).not_to have_button("Category")
      fill_in("generic_file[comments_attributes][0][content]", with: comment0)
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment0
      expect(page).to have_button("Category")
      fill_in("generic_file[comments_attributes][1][content]", with: comment1)
      within("div.comments-editor") { find_button('Add').click }
      fill_in("generic_file[comments_attributes][2][content]", with: comment2)
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment0
      expect(find_field("generic_file[comments_attributes][1][content]").value).to eql comment1
      expect(find_field("generic_file[comments_attributes][2][content]").value).to eql comment2    
      within("div.comments-editor") { first(:button, "Remove").click }
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment1
      expect(find_field("generic_file[comments_attributes][1][content]").value).to eql comment2
    end
  end

  context "with aictags" do
    let(:aictag0) { "The first tag"  }
    let(:aictag1) { "The second tag" }
    let(:aictag2) { "The third tag"  }

    it "supports adding and removing" do
      visit sufia.edit_generic_file_path(file)
      expect(page).to have_content("Edit #{title}")
      expect(page).not_to have_button("Category")
      fill_in("generic_file[aictags_attributes][0][content]", with: aictag0)
      click_button("upload_submit")
      expect(find_field("generic_file[aictags_attributes][0][content]").value).to eql aictag0
      expect(page).to have_button("Category")
      fill_in("generic_file[aictags_attributes][1][content]", with: aictag1)
      within("div.aictags-editor") { find_button('Add').click }
      fill_in("generic_file[aictags_attributes][2][content]", with: aictag2)
      click_button("upload_submit")
      expect(find_field("generic_file[aictags_attributes][0][content]").value).to eql aictag0
      expect(find_field("generic_file[aictags_attributes][1][content]").value).to eql aictag1
      expect(find_field("generic_file[aictags_attributes][2][content]").value).to eql aictag2    
      within("div.aictags-editor") { first(:button, "Remove").click }
      click_button("upload_submit")
      expect(find_field("generic_file[aictags_attributes][0][content]").value).to eql aictag1
      expect(find_field("generic_file[aictags_attributes][1][content]").value).to eql aictag2
    end
  end  

end
