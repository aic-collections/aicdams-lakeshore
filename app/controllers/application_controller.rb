class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  include Blacklight::Controller
  include Sufia::Controller
  include Hydra::Controller::ControllerBehavior
  include Devise::Behaviors::SamlAuthenticatableBehavior

  layout 'sufia-one-column'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_authorization, :authenticate_user!, :clear_session_user

  # Ensures any user is logged out if they don't match the current SAML user
  def clear_session_user
    return if current_user && current_user.email == saml_user
    request.env['warden'].logout
    redirect_to(root_path)
  end

  def check_authorization
    render_401 unless valid_saml_credentials?
  end

  def render_401
    render template: '/error/401', layout: "error", formats: [:html], status: 401
  end
end
