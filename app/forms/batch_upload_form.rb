# frozen_string_literal: true
class BatchUploadForm < Sufia::Forms::BatchUploadForm
  include AssetFormBehaviors

  self.terms = CurationConcerns::GenericWorkForm.terms

  def primary_terms
    CurationConcerns::GenericWorkForm.aic_terms - [:asset_type, :pref_label]
  end

  def secondary_terms
    []
  end

  def dept_created
    Department.find_by_citi_uid(current_ability.current_user.department)
  end

  def uri_for(term)
    # noop
  end

  def uris_for(term)
    # noop
  end

  def representations_for
    []
  end

  def documents_for
    []
  end

  def visibility
    ::Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
  end
end
