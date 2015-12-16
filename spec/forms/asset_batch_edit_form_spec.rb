require 'rails_helper'

describe AssetBatchEditForm do
  describe "::terms" do
    subject { described_class.terms }
    it { is_expected.not_to include(:pref_label) }
  end
end
