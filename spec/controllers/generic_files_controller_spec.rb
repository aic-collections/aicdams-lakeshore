require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end

  describe "update" do
    let(:generic_file) do
      GenericFile.create do |gf|
        gf.apply_depositor_metadata(user)
      end
    end

    describe "nested attributes" do
      let(:attributes) do
        { 
          title: ['new_title'], 
          comments_attributes: [{content: "foo comment", category: ["bar category"]}],
          tags_attributes: [{content: "foo tag", category: ["bar category"]}],
          permissions_attributes: [{ type: 'person', name: 'archivist1', access: 'edit'}]
        }
      end

      before { post :update, id: generic_file, generic_file: attributes }
      subject { generic_file.reload }

      it "should set the values using the parameters hash" do
        expect(subject.comments.first.content).to eql "foo comment"
        expect(subject.comments.first.category).to eql ["bar category"]
        expect(subject.tags.first.content).to eql "foo tag"
        expect(subject.tags.first.category).to eql ["bar category"]
      end
    end

  end

end
