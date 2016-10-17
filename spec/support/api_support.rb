# frozen_string_literal: true
module APISupport
  def sign_in_basic(user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
  end
end
