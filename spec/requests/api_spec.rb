require 'rails_helper'

describe "The API" do

  describe "reindexing resources" do
    context "with correct input" do
      let(:body) { '["res1", "res2", "res3"]' }
      before do
        allow_any_instance_of(ReindexController).to receive(:reindex_submitted_ids).and_return(true)
        post "/api/reindex", body
      end
      it "returns a successful response" do
        expect(response.status).to eql 200
      end
    end

    context "with incorrect input" do
      let(:body) { '{"bogus": "json"}' }
      before { post "/api/reindex", body }
      subject { response.status }
      it { is_expected.to eql 400 }
    end

    context "with bogus input" do
      before { post "/api/reindex", "junk" }
      subject { response.status }
      it { is_expected.to eql 500 }
    end
  end

end
