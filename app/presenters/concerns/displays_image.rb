# frozen_string_literal: true

# This gets mixed into FileSetPresenter in order to create
# a canvas on a IIIF manifest
module DisplaysImage
  extend ActiveSupport::Concern

  def display_image
    hit = ActiveFedora::SolrService.query("id:#{id}")
    return nil if hit[0].nil?

    # we do not want to display any image but the access_master
    return unless image_is_access_master(hit)
    url = DerivativePath.access_path(id)
    doc = SolrDocument.new(hit[0])

    IIIFManifest::DisplayImage.new(url, width: doc.width, height: doc.height, iiif_endpoint: iiif_endpoint(id))
  end

  private

    def image_is_access_master(solr_doc)
      # I believe IntermediateFileSet is the access master
      solr_doc[0][:rdf_types_ssim].include?("http://definitions.artic.edu/ontology/1.0/type/IntermediateFileSet")
    end

    def base_image_url(fileset_id)
      uri = Riiif::Engine.routes.url_helpers.info_url(fileset_id, host: request.base_url)
      # TODO: There should be a riiif route for this:
      uri.sub(%r{/info\.json\Z}, '')
    end

    def iiif_endpoint(fileset_id)
      IIIFManifest::IIIFEndpoint.new(base_image_url(fileset_id), profile: "http://iiif.io/api/image/2/level2.json")
    end
end
