require 'rails_helper'
require 'cancan/matchers'

describe Sufia::Ability do
  let(:user1) { create(:user1) }
  let(:user2) { create(:user2) }

  let(:file) do
    GenericFile.create.tap do |f|
      f.apply_depositor_metadata(user1)
      f.assert_still_image
      f.save
    end
  end

  context "with department visibility" do
    context "registered users cannot read a GenericFile" do
      subject { Ability.new(user2) }
      it { is_expected.not_to be_able_to(:read, file) }
    end
  end
end
