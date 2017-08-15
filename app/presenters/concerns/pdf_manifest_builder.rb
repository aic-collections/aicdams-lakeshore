# frozen_string_literal: true
module PDFManifestBuilder
  def add_media_sequences(manifest, media_info)
    json_manifest = JSON.parse(manifest.to_json)
    json_manifest["mediaSequences"] = [media_sequence(media_info)]
    json_manifest["@context"] = ["http://iiif.io/api/image/2/context.json", "http://wellcomelibrary.org/ld/ixif/0/context.json"]
    json_manifest
  end

  def media_sequence(media_info)
    @elements ||=
      begin
        elements = {}
        elements["@id"] = media_info[:access_url]
        elements["format"] = "application/pdf"
        elements["@type"] = "foaf:Document"
        elements["label"] = media_info[:label]
        elements["rendering"] = [{
          "@id": media_info[:access_url],
          "format": "application/pdf",
          "label": media_info[:label]
        }]
        elements["thumbnail"] = media_info[:thumbnail_url]
      end
    @media_sequence ||=
      begin
        media_sequence = {}
        media_sequence["@type"] ||= "ixif:MediaSequence"
        media_sequence["label"] ||= "Contents"
        media_sequence["rendering"] = []
        media_sequence["elements"] = [elements]
        media_sequence
      end
  end
end
