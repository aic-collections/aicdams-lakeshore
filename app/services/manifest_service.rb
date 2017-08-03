# frozen_string_literal: true
class ManifestService
  attr_reader :presenter

  # @param [AssetPresenter] presenter
  def initialize(presenter)
    @presenter = presenter
  end

  # @param [String] image
  def image_url(image)
    "/downloads/#{file_set_id}?file=#{image}"
  end

  def file_set_id
    presenter.solr_document["hasRelatedImage_ssim"].first
  end

  def text?
    presenter.solr_document.type.include?(AICType.Text)
  end

  # @return [Hash]
  def media_info
    { label: presenter.title.first, thumbnail_url: image_url("thumbnail"), access_url: image_url("accessMaster") }
  end

  # @return [JSON]
  # We need a ManifestFactory object and to be able to add media_sequences to it.
  # Its to_h is connected to a lot of internal state, is not just the creation of a hash
  def manifest_builder
    builder = IIIFManifest::ManifestFactory.new(presenter)
    builder.extend PDFManifestBuilder
    manifest = builder.to_h
    if text?
      builder.add_media_sequences(manifest, media_info)
    else
      JSON.parse(manifest.to_json)
    end
  end
end
