# frozen_string_literal: true
require 'devise/strategies/saml_authenticatable'
module Devise
  module Models
    module SamlAuthenticatable
      extend ActiveSupport::Concern

      def after_database_authentication
      end
    end
  end
end
