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

  def link_to_asset asset
    if asset.title.empty?
      link_to sufia.generic_file_path(asset)
    else
      link_to asset.title.first, sufia.generic_file_path(asset)
    end
  end

end
