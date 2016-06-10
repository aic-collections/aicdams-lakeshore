# frozen_string_literal: true
class User < ActiveRecord::Base
  include Hydra::User
  include CurationConcerns::User
  include Sufia::User
  include Sufia::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end

  Devise.add_module(:saml_authenticatable,
                    strategy: true,
                    controller: :sessions,
                    model: 'devise/models/saml_authenticatable')

  devise :saml_authenticatable

  # TODO: Add additional attributes from Shibboleth properties
  def populate_attributes
    self
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def admin?
    groups.include?('admin')
  end

  def groups
    groups = super
    groups << department
    groups
  end

  class << self
    def find_by_email(query)
      User.where(email: query).first
    end

    def batchuser
      User.find_by_user_key(batchuser_key) || User.create!(email: batchuser_key)
    end

    def batchuser_key
      'batchuser'
    end

    def audituser
      User.find_by_user_key(audituser_key) || User.create!(email: audituser_key)
    end

    def audituser_key
      'audituser'
    end
  end
end
