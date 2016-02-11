# Default strategy for signing in a user, based on his email and password in the database.
module Devise
  module Strategies
    class SamlAuthenticatable < ::Devise::Strategies::Base
      include Devise::Behaviors::SamlAuthenticatableBehavior

      # Called if the user doesn't already have a rails session cookie
      def valid?
        valid_saml_credentials?
      end

      def authenticate!
        return fail! unless valid? || authenticated_saml_user
        update_saml_department
        success!(authenticated_saml_user)
      end

      private

        def authenticated_saml_user
          @authenticated_saml_user ||= User.find_by_user_key(saml_user) || User.create!(email: saml_user)
        end

        def update_saml_department
          return if authenticated_saml_user.department == saml_department
          authenticated_saml_user.department = saml_department
          authenticated_saml_user.save!
        end
    end
  end
end

Warden::Strategies.add(:saml_authenticatable, Devise::Strategies::SamlAuthenticatable)
