require 'rails_helper'

describe GenericFile do

  subject { GenericFile.new }

  describe "included properties from Sufia" do

    it { is_expected.to respond_to(:contributor) }
    it { is_expected.to respond_to(:creator) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:identifier) }
    it { is_expected.to respond_to(:language) }
    it { is_expected.to respond_to(:publisher) }
    it { is_expected.to respond_to(:rights) }
    it { is_expected.to respond_to(:source) }
    it { is_expected.to respond_to(:subject) }
    it { is_expected.to respond_to(:title) }

  end

  describe "additional properties not in Sufia" do

    context "DC terms" do
      it { is_expected.to respond_to(:coverage) }
      it { is_expected.to respond_to(:date) }
      it { is_expected.to respond_to(:format) }
      it { is_expected.to respond_to(:relation) }
      # Sufia type is reserved to http://pcdm.org/models#Object
      it { is_expected.to respond_to(:aic_type) }
    end

    context "AIC terms" do
      it { is_expected.to respond_to(:batch_uid) }
      it { is_expected.to respond_to(:dept_created) }
      it { is_expected.to respond_to(:has_comment) }
      it { is_expected.to respond_to(:has_location) }
      it { is_expected.to respond_to(:has_metadata) }
      it { is_expected.to respond_to(:has_publishing_context) }
      it { is_expected.to respond_to(:has_tag) }
      it { is_expected.to respond_to(:uid) }
    end

    context "SKOS terms" do
      it { is_expected.to respond_to(:pref_label) }
    end
  end

end
