module ApplicationHelper

  def track_work_path(*args)
    track_solr_document_path(*args)
  end

end
