require 'rails_helper'

describe TagCatEditForm do
  subject { described_class.new(TagCat.new) }

  describe "#terms" do
    it "should return a list" do
      expect(subject.terms).to eq([:pref_label])
    end
  end

  describe "#pref_label" do
    specify "is single-valued" do
      expect(subject.pref_label).to eql ""
    end
    specify "is required" do
      expect(subject.required_fields).to include(:pref_label)
    end
  end

  describe ".model_attributes" do
    let(:params) do 
      ActionController::Parameters.new(
        pref_label: "foo", 
        permissions_attributes: {"2"=>{"access"=>"edit", "_destroy"=>"true", "id"=>"a987551e-b87f-427a-8721-3e5942273125"}}
      )
    end
    subject { described_class.model_attributes(params) }

    it "should add the pref_label" do
      expect(subject["pref_label"]).to eq "foo"
      expect(subject["permissions_attributes"]).to eq("2" => {"access"=>"edit", "id"=>"a987551e-b87f-427a-8721-3e5942273125", "_destroy"=>"true"})
    end
  end

end