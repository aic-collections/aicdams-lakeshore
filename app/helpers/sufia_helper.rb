module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def url_for_document doc, options = {}
    if (doc.is_a?(SolrDocument) && doc.hydra_model.match(/Work|Actor|Exhibition/))
      doc
    else
      [sufia, doc]
    end
  end

end
