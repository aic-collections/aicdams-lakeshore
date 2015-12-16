require 'rails_helper'

describe UidTranslator do
  describe "::id_to_uri" do
    context "with a prefixed id" do
      let(:id) { "SI-123456" }
      subject { described_class.id_to_uri(id) }
      it { is_expected.to match(/SI\/12\/34\/56\/SI-123456$/) }
    end

    context "with a default noid from Sufia" do
      let(:id) { "df67si12rg" }
      subject { described_class.id_to_uri(id) }
      it { is_expected.to match(/df\/67\/si\/12\/df67si12rg$/) }
    end
  end
end
