require 'rails_helper'

describe UidMinter do

  let(:service) { described_class.new("XX") }

  context "when faking a uid for testing purposes" do
    subject { service.mint }
    it { is_expected.to match(/^XX-\d\d\d\d\d\d$/) }
  end

  context "when using the response from the Postgres procedure" do
    let(:response) { ActiveRecord::Result.new(["newid"], [["TX-000003"]]) }
    before { allow(service).to receive(:new_uid).and_return(response) }
    subject { service.uid_from_database }
    it { is_expected.to eql("TX-000003") }
  end

end
