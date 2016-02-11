module Devise::Behaviors::SamlAuthenticatableBehavior
  def valid_saml_credentials?
    saml_user.present? && saml_department.present?
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

  private

    def saml_unscoped_affiliation
      @saml_unscoped_affiliation ||= request.env.fetch("HTTP_SAML_UNSCOPED_AFFILIATION", nil)
    end
end
