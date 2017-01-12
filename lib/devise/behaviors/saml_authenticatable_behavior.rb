# frozen_string_literal: true
module Devise::Behaviors::SamlAuthenticatableBehavior
  def valid_saml_credentials?
    saml_user.present? && saml_department.present? && aic_user.present? && department.present?
  end

  def saml_user
    request.env.fetch("HTTP_SAML_UID", nil)
  end

  def saml_department
    request.env.fetch("HTTP_SAML_PRIMARY_AFFILIATION", nil)
  end

  def saml_groups
    return [] unless saml_unscoped_affiliation
    saml_unscoped_affiliation.split(";")
  end

  def aic_user
    AICUser.find_by_nick(saml_user, with_solr: true)
  end

  def department
    Department.find_by_citi_uid(saml_department, with_solr: true)
  end

  private

    def saml_unscoped_affiliation
      @saml_unscoped_affiliation ||= request.env.fetch("HTTP_SAML_UNSCOPED_AFFILIATION", nil)
    end
end
