# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form.html.erb' do
  let(:user)    { create(:user1) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(work, ability) }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  context "with a new asset" do
    let(:work) { GenericWork.new }
    before do
      view.stub(:action_name).and_return('new')
      render
    end
    it "includes select options for asset type" do
      expect(rendered).to include("<option value=\"#{AICType.StillImage}\">Still Image</option>")
      expect(rendered).to include("<option value=\"#{AICType.Text}\">Text</option>")
    end
    it "does not show the status select input" do
      expect(rendered).not_to include("generic_work_status_uri")
    end
    it "displays the correct visibility options" do
      expect(page).to have_checked_field('generic_work_visibility_department')
    end
  end

  context "when editing an existing asset" do
    let(:work) { create(:asset) }
    before { render }
    it "renders the asset type as a hidden field with the current value" do
      expect(rendered).to include("type=\"hidden\" value=\"#{AICType.StillImage}\"")
    end
    it "renders the existing status selected" do
      expect(rendered).to include("<option selected=\"selected\" value=\"#{StatusType.active.uri}\">Active</option>")
    end
  end

  context "with singular terms using list items" do
    let(:item) { create(:list_item) }
    let(:addl) { create(:list_item, pref_label: "Additional Item") }
    let(:work) { create(:asset, compositing: item,
                                light_type: item,
                                digitization_source: item,
                                view: [item, addl]) }

    before do
      allow(BaseVocabulary).to receive(:all).and_return([item, addl])
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
    end
  end
end
