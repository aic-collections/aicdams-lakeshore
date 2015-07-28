module ApplicationHelper

  def track_work_path(*args)
    track_solr_document_path(*args)
  end

  def render_work_visibility_badge
    if can? :edit, @work
      render_visibility_link @work
    else
      render_visibility_label @work
    end
  end

end
