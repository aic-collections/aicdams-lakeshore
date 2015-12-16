require 'rails_helper'

describe ShipmentPresenter do
  it_behaves_like "a presenter with terms for a Citi resource"
  it_behaves_like "a presenter with related assets"

  describe "#summary_terms" do
    subject { described_class.new(described_class.model_class.new) }
    its(:summary_terms) { is_expected.to contain_exactly(:uid, :created_by, :resource_created, :resource_updated) }
  end
end
