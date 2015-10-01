require 'rails_helper'

describe ActorEditForm do
  subject { described_class.new(Actor.new) }

  describe ".model_attributes" do
    let(:params) do 
      ActionController::Parameters.new( document_ids: [""] )
    end
    subject { described_class.model_attributes(params) }

    it "removes empty strings" do
      expect(subject["document_ids"]).to be_empty
    end
  end

end
