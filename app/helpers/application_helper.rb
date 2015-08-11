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

  def link_to_asset(asset)
    if asset.title.empty?
      link_to asset_image_tag(asset), sufia.download_path(asset), target: "_blank", title: "Download the document", id: "file_download", data: { label: asset.id }
    else
      link_to asset_image_tag(asset), sufia.download_path(asset), target: "_blank", title: "#{asset.title.first}", id: "file_download", data: { label: asset.id }
    end
  end

  def asset_image_tag(asset)
    if asset.title.empty?
      image_tag "default.png", alt: "No preview available", class: "img-responsive"
    else
      image_tag sufia.download_path(asset, file: 'thumbnail'), class: "img-responsive", alt: "#{asset.title.first}"
    end
  end

end
