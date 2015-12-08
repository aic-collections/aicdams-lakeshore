require 'rails_helper'

describe User do

  describe "ADMINS" do
    subject { ADMINS }
    it { is_expected.to include("joe@aic.org") }
    it { is_expected.to be_kind_of(Array) }
  end

  context "with an admin" do
    let(:user) { stub_model(User, email: "joe@aic.org") }
    describe "#admin?" do
      subject { user.admin? }
      it { is_expected.to be true }
    end
    describe "#groups" do
      subject { user }
      its(:groups) { is_expected.to contain_exactly("admin", "registered") }
    end  
  end

  context "without an admin" do
    let(:user) { stub_model(User, email: "bob@aic.org") }
    describe "#admin?" do
      subject { user.admin? }
      it { is_expected.to be false }
    end
    describe "#groups" do
      subject { user }
      its(:groups) { is_expected.to contain_exactly("registered") }
    end 
  end

end
