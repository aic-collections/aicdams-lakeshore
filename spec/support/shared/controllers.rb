shared_examples "a controller for a Citi resource" do |resource_name|

  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:resource)      { resource_name.capitalize.constantize.create }
  let(:param_key) { resource_name.downcase }

  describe "#edit" do
    before { get :edit, id: resource }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#update" do

    context "with a document" do
      let(:document) do
        GenericFile.create.tap do |f|
          f.title = ["Document for a resource"]
          f.apply_depositor_metadata user
          f.assert_text
          f.save
        end
      end
      before { post :update, id: resource, param_key.to_sym => { document_ids: [document.id] } }
      specify do
        expect(response).to be_redirect
        expect(resource.reload.document_ids).to contain_exactly(document.id)
      end
    end

    context "with a representation" do
      let(:representation) do
        GenericFile.create.tap do |f|
          f.title = ["Representation of a resource"]
          f.apply_depositor_metadata user
          f.assert_still_image
          f.save
        end
      end
      before { post :update, id: resource, param_key.to_sym => { representation_ids: [representation.id] } }
      specify do
        expect(response).to be_redirect
        expect(resource.reload.representation_ids).to contain_exactly(representation.id)
      end    
    end

    context "with a preferred representation" do
      let(:preferred_representation) do
        GenericFile.create.tap do |f|
          f.title = ["Preferred representation of a resource"]
          f.apply_depositor_metadata user
          f.assert_still_image
          f.save
        end
      end
      before { post :update, id: resource, param_key.to_sym => { preferred_representation_ids: [preferred_representation.id] } }
      specify do
        expect(response).to be_redirect
        expect(resource.reload.preferred_representation_ids).to contain_exactly(preferred_representation.id)
      end
    end
  end

  describe "#show" do
    before { get :show, id: resource }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#index" do
    before { get :index }
    subject { response }
    it { is_expected.to be_redirect }
  end

end
