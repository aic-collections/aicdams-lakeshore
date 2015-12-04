require 'rails_helper'

describe RepresentingResource do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:example_file) do
    GenericFile.create.tap do |file|
      file.apply_depositor_metadata(user)
      file.assert_still_image
      file.save
    end
  end

  subject { described_class.new(example_file.id) }

  context "with an asset that is not any kind of representation" do
    it { is_expected.not_to be_representing }
  end

  context "with a nil id" do
    subject { described_class.new(nil) }
    its(:documents) { is_expected.to be_empty }
    its(:representations) { is_expected.to be_empty }
    its(:preferred_representations) { is_expected.to be_empty }
    its(:assets) { is_expected.to be_empty }
  end
end
