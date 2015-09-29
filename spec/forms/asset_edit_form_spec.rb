require 'rails_helper'

describe AssetEditForm do

  describe "::build_permitted_params" do
    let(:resources_by_id) { [ :aictag_ids, :tagcat_ids, :asset_ids, :document_ids, :representation_ids, :preferred_representation_ids ]}
    let(:params_keys) { AssetEditForm.build_permitted_params.map {|c| c.keys if c.is_a? Hash }.flatten }
    let(:comments_attributes) { { comments_attributes: [:id, :_destroy, :content, {category: []}] } }
    specify { expect(params_keys).to include(:comments_attributes, *resources_by_id) }
    specify { expect(AssetEditForm.build_permitted_params).to include(comments_attributes) }
  end

  describe "#initialize_field" do

    context "with comments" do
      let(:c1) { Comment.create(content: "first comment") }
      let(:c2) { Comment.create(content: "second comment") }
      let(:generic_file) do
        GenericFile.create.tap do |file|
          file.comments = [c1, c2]
          file.title = ["Commented resource"]
          file.apply_depositor_metadata "user"
          file.assert_still_image
          file.save!
        end
      end
      let(:form) { AssetEditForm.new(generic_file) }
      subject { form[:comments] }
      it { is_expected.to include(c1, c2) }
    end

    context "without comments" do
      let(:generic_file) do
        GenericFile.create.tap do |file|
          file.title = ["Un-Commented resource"]
          file.apply_depositor_metadata "user"
          file.assert_still_image
          file.save!
        end
      end
      let(:form) { AssetEditForm.new(generic_file) }
      subject { form[:comments] }
      it { is_expected.to include(Comment) }
    end

  end

  describe ".model_attributes" do
    let(:params) do 
      ActionController::Parameters.new( aictag_ids: [""] )
    end
    subject { described_class.model_attributes(params) }

    it "removes empty strings" do
      pending "this needs to apply to documents, representations and preferred representations"
      expect(subject["aictag_ids"]).to be_empty
    end
  end

  describe ".terms" do
    subject { described_class.terms }
    it { is_expected.not_to include(:uid) }
  end

end
