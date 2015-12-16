require 'rails_helper'
require 'cancan/matchers'

describe Sufia::Ability do
  let(:user) { FactoryGirl.find_or_create(:user) }
  let(:jill) { FactoryGirl.find_or_create(:jill) }

  let(:file) do
    GenericFile.create.tap do |f|
      f.apply_depositor_metadata(jill)
      f.assert_still_image
      f.save
    end
  end

  context "with department visibility" do
    context "registered users cannot read a GenericFile" do
      subject { Ability.new(user) }
      it { is_expected.not_to be_able_to(:read, file) }
    end
  end
end
