module ApplicationHelper

  def track_work_path(*args)
    track_solr_document_path(*args)
  end

  def track_actor_path(*args)
    track_solr_document_path(*args)
  end

  def track_exhibition_path(*args)
    track_solr_document_path(*args)
  end

  def track_transaction_path(*args)
    track_solr_document_path(*args)
  end

  def track_shipment_path(*args)
    track_solr_document_path(*args)
  end

  def render_resource_visibility_badge
    if can? :edit, @resource
      render_visibility_link @resource
    else
      render_visibility_label @resource
    end
  end

  def edit_resource_path
    send("edit_#{@resource.class.to_s.downcase}_path", @resource)
  end

  def link_to_asset(asset)
    if asset.title.empty?
      link_to asset_image_tag(asset), sufia.generic_file_path(asset), title: "Download the document", id: "file_download", data: { label: asset.id }
    else
      link_to asset_image_tag(asset), sufia.generic_file_path(asset), title: "#{asset.title.first}", id: "file_download", data: { label: asset.id }
    end
  end

  def asset_image_tag(asset)
    if asset.title.empty?
      image_tag "default.png", alt: "No preview available", class: "media-object", width: "150"
    else
      image_tag sufia.download_path(asset, file: 'thumbnail'), class: "media-object", width: "150", alt: "#{asset.title.first}"
    end
  end

  def resource_type_facets
    @resource_types.reject { |r| r.kind_of?(Integer) }.sort
  end

end
