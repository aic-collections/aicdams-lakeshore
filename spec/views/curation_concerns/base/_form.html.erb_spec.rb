# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form.html.erb' do
  let(:user)    { create(:user1) }
  let(:ability) { Ability.new(user) }
  let(:form)    { CurationConcerns::GenericWorkForm.new(work, ability) }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(view).to receive(:controller_name).and_return("generic_works")
    assign(:form, form)
  end

  before(:all) { LakeshoreTesting.restore }

  context "with a new asset" do
    let(:work) { GenericWork.new }
    before do
      allow(view).to receive(:action_name).and_return('new')
      render
    end
    it "includes select options for asset type" do
      expect(rendered).to include("<option value=\"#{AICType.StillImage}\">Still Image</option>")
      expect(rendered).to include("<option value=\"#{AICType.Text}\">Text</option>")
      expect(rendered).to include("<option value=\"#{AICType.Dataset}\">Dataset</option>")
      expect(rendered).to include("<option value=\"#{AICType.Archive}\">Archive</option>")
      expect(rendered).to include("<option value=\"#{AICType.Sound}\">Sound</option>")
      expect(rendered).to include("<option value=\"#{AICType.MovingImage}\">Moving Image</option>")
    end
    it "does not show the status select input" do
      expect(rendered).not_to include("generic_work_status_uri")
    end
    it "displays the correct visibility options" do
      expect(page).to have_checked_field('generic_work_visibility_department')
    end
    it "displays the first document type selection option" do
      expect(page).to have_select('generic_work_document_type_uri')
      expect(page).not_to have_select('generic_work_first_document_sub_type_uri')
      expect(page).not_to have_select('generic_work_second_document_sub_type_uri')
    end
    it "displays the correct field labels" do
      expect(page).to have_selector("label", text: "Original Source")
      expect(page).to have_selector("label", text: "Image View")
      expect(page).to have_selector("label", text: "Image Capture Light Type")
      expect(page).to have_selector("label", text: "Image Compositing")
      expect(page).to have_selector("label", text: "Description")
    end
    it "public domain defaults to false" do
      expect(page).to have_unchecked_field("generic_work_public_domain")
    end
  end

  context "when editing an existing asset" do
    let(:work) { create(:asset, pref_label: "Hello") }
    before { render }

    it "renders the asset type as a hidden field with the current value" do
      expect(rendered).to include("type=\"hidden\" value=\"#{AICType.StillImage}\"")
    end
    it "renders the existing status selected" do
      expect(rendered).to include("<option selected=\"selected\" value=\"#{ListItem.active_status.uri}\">Active</option>")
    end
    it "renders hints after labels and before inputs" do
      expect(page.find('.generic_work_pref_label label + .help-block')).to have_content 'Preferred title or name of the resource. This will be the principal value for the \'alt\' tag of web images.'

      expect(page.find('.generic_work_pref_label .help-block + input').value).to eq('Hello')
    end
  end

  context "with existing document types" do
    let(:work) do
      create(:asset,
             document_type_uri: "http://doctype-uri",
             first_document_sub_type_uri: "http://first-sub-type-uri",
             second_document_sub_type_uri: "http://second-sub-type-uri"
            )
    end
    before do
      allow(view).to receive(:action_name).and_return('edit')
      render
    end

    it "renders existing uris as data attributes" do
      expect(rendered).to include('data-uri="http://doctype-uri">')
      expect(rendered).to include('data-uri="http://first-sub-type-uri">')
      expect(rendered).to include('data-uri="http://second-sub-type-uri">')
    end
  end

  context "with list items" do
    let(:item) { create(:list_item) }
    let(:addl) { create(:list_item, pref_label: "Additional Item") }
    let(:work) { create(:asset, compositing: item.uri,
                                light_type: item.uri,
                                digitization_source: item.uri,
                                licensing_restrictions: [item.uri, addl.uri],
                                view: [item.uri, addl.uri]) }

    before do
      allow(ListOptionsService).to receive(:call).and_return("Item 1" => item.uri, "Additional Item" => addl.uri)
      render
    end

    subject { Capybara::Node::Simple.new(rendered) }

    it "renders the selected item" do
      is_expected.to have_select('generic_work_compositing_uri', selected: item.pref_label)
      is_expected.to have_select('generic_work_light_type_uri', selected: item.pref_label)
      is_expected.to have_select('generic_work_digitization_source_uri', selected: item.pref_label)
      within("div.generic_work_view_uris") do
        is_expected.to have_content("<option selected=\"selected\" value=\"#{item.uri}\">#{item.pref_label}</option>")
        is_expected.to have_content("<option selected=\"selected\" value=\"#{addl.uri}\">#{addl.pref_label}</option>")
      end
      within("div.generic_work_licensing_restriction_uris") do
        is_expected.to have_content("<option selected=\"selected\" value=\"#{item.uri}\">#{item.pref_label}</option>")
        is_expected.to have_content("<option selected=\"selected\" value=\"#{addl.uri}\">#{addl.pref_label}</option>")
      end
    end
  end

  describe "publish_channel_uris" do
    let(:work) { create(:asset) }

    subject { Capybara::Node::Simple.new(rendered) }

    context "when the user does not have permission to edit the field" do
      before { render }

      it "is disabled" do
        is_expected.to have_select('generic_work_publish_channel_uris', disabled: true)
      end
    end

    context "when the user has permission to edit the field" do
      let(:user) { create(:admin) }

      before { render }

      it "is enabled" do
        is_expected.to have_select('generic_work_publish_channel_uris')
      end
    end
  end

  describe "copyright_representatives" do
    let(:representative) { build(:agent, id: "rep-1", pref_label: "Sample Agent") }
    let(:work) { create(:asset) }

    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(work).to receive(:copyright_representatives).and_return([representative])
      render
    end

    subject { Capybara::Node::Simple.new(rendered) }

    it "displays the existing representative" do
      expect(page.all("input#generic_work_copyright_representatives", visible: false).first.value).to eq(representative.id)
    end
  end
end
