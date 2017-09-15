# frozen_string_literal: true
module Devise::Behaviors::SamlAuthenticatableBehavior
  def valid_saml_credentials?
    return true if saml_user.present? && saml_department.present? && aic_user.present? && department.present?
    Rails.logger.error("One or more required credentials are missing: #{report.join('; ')}")
    false
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
    @aic_user ||= AICUser.find_by_nick(saml_user, with_solr: true)
  end

  def department
    @department ||= Department.find_by_citi_uid(saml_department, with_solr: true)
  end

  def report
    [
      "HTTP_SAML_UID (required): #{saml_user || '--missing--'}",
      "HTTP_SAML_PRIMARY_AFFILIATION (required): #{saml_department || '--missing--'}",
      "HTTP_SAML_UNSCOPED_AFFILIATION: #{saml_unscoped_affiliation || '--missing--'}",
      "AIC user (required): #{aic_user || '--missing--'}",
      "AIC department (required): #{department || '--missing--'}"
    ]
  end

  private

    def saml_unscoped_affiliation
      @saml_unscoped_affiliation ||= request.env.fetch("HTTP_SAML_UNSCOPED_AFFILIATION", nil)
    end
end
