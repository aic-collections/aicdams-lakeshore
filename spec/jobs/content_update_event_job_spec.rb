require 'rails_helper'

describe ContentUpdateEventJob do
  let(:user) { create(:user1) }
  let(:generic_file) do
    GenericFile.create.tap do |file|
      file.title = ["Event job file"]
      file.apply_depositor_metadata user
      file.assert_still_image
      file.save
    end
  end

  context "when calling the job directly" do
    before do
      allow(User).to receive(:find_by_user_key).and_return(user)
      described_class.new(generic_file.id, user.id).run
    end

    it "adds messages to the user and file events queue" do
      expect(user.profile_events).not_to be_empty
      expect(generic_file.events).not_to be_empty
    end
  end

  context "when sumitting the job to the queue" do
    before do
      allow(User).to receive(:find_by_user_key).and_return(user)
      Sufia.queue.push(ContentDepositEventJob.new(generic_file.id, user.user_key))
    end

    it "adds messages to the user and file events queue" do
      expect(user.profile_events).not_to be_empty
      expect(generic_file.events).not_to be_empty
    end
  end
end
