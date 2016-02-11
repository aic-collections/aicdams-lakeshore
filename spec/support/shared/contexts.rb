shared_context "authenticated saml user" do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    allow(controller).to receive(:valid_saml_credentials?).and_return(true)
    allow(controller).to receive(:clear_session_user).and_return(user)
    allow_any_instance_of(Devise::Strategies::SamlAuthenticatable).to receive(:saml_user).and_return(user.email)
    allow_any_instance_of(Devise::Strategies::SamlAuthenticatable).to receive(:saml_department).and_return(user.department)
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end
end
