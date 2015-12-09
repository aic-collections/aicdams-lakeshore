require 'rails_helper'

describe ListItemEditForm do

  subject { described_class.new(ListItem.new()) }
    
  its(:terms) { is_expected.to contain_exactly(:pref_label, :description) }

  describe "#model_attributes" do
    let(:list_item) { { "pref_label" => "New Thing", "description" => ["Description of new thing."] } }
    let(:params) { ActionController::Parameters.new(list_item) }
    specify do
      expect(described_class.model_attributes(params)).to eq(list_item)
    end
  end
end
