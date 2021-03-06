# frozen_string_literal: true
module PrependedRenderers::WithRightsAttributeToHtml
  # Special treatment for license/rights.  A URL from the Sufia gem's config/sufia.rb is stored in the descMetadata of the
  # curation_concern.  If that URL is valid in form, then it is used as a link.  If it is not valid, it is used as plain text.
  def rights_attribute_to_html(value)
    begin
      parsed_uri = URI.parse(value)
    rescue
      nil
    end
    if parsed_uri.nil?
      ERB::Util.h(value)
    else
      %(<a href=#{ERB::Util.h(value)} target="_blank">#{CurationConcerns::LicenseService.new.label(value) { value }}</a>)
    end
  end
end
