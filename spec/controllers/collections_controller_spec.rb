# frozen_string_literal: true
require 'rails_helper'

describe CollectionsController do
  describe "::presenter_class" do
    subject { described_class }
    its(:presenter_class) { is_expected.to eq(CollectionPresenter) }
    its(:form_class) { is_expected.to eq(CollectionForm) }
  end
end
