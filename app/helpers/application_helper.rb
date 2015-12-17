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

  def resource_path(resource)
    send("#{resource.class.to_s.downcase}_path", resource)
  end

  def link_to_resource(resource)
    link_to resource_image_tag, resource_path(resource), title: "#{resource.pref_label}", id: "show_resource", data: { label: resource.id }
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

  def resource_image_tag
    image_tag "default.png", alt: "No preview available", class: "media-object", width: "150"
  end

  def resource_type_facets
    @resource_types.reject { |r| r.is_a?(Integer) }.sort
  end

  def link_to_citi(controllername, citiid)
    if controllername == "works"
      tableid = 3
    elsif controllername == "exhibitions"
      tableid = 151
    elsif controllername == "transactions"
      tableid = 167
    elsif controllername == "shipments"
      tableid = 180
    end
    link_to "View this object in CITI", "http://citiworker10.artic.edu:8080/edit/?tableID=" + tableid.to_s + "&uid=" + citiid.to_s, target: "_blank"
  end
end
