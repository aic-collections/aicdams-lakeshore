module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def url_for_document(doc, _options = {})
    if doc.is_a?(SolrDocument) && doc.hydra_model.match(/Work|Actor|Exhibition|Transaction|Shipment/)
      doc
    else
      [sufia, doc]
    end
  end

  def render_visibility_label(document)
    if document.registered?
      content_tag :span, t('sufia.institution_name'), class: "label label-info", title: t('sufia.institution_name')
    elsif document.public?
      content_tag :span, t('sufia.visibility.open'), class: "label label-success", title: t('sufia.visibility.open_title_attr')
    elsif document.private?
      content_tag :span, t('sufia.visibility.private'), class: "label label-danger", title: t('sufia.visibility.private_title_attr')
    else
      content_tag :span, "Department", class: "label label-warning", title: t('sufia.visibility.open_title_attr')
    end
  end

  def user_display_name_and_key(key)
    agent = AICUser.find_by_nick(key) || Department.find_by_department_key(key)
    CitiResourcePresenter.new(agent).display_name
  end
end
