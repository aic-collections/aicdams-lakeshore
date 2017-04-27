# frozen_string_literal: true
# Module for working with other Fedora resources that we want to reference as uris. This is required
# when the object of a triple is another Fedora resource and provides generated methods where we
# can call the related resource using its URI instead of using a full ActiveFedora object.
module AcceptsUris
  extend ActiveSupport::Concern

  class_methods do
    # Defines a x_uris= or x_uri= method where "x" is the property
    def accepts_uris_for(*fields)
      fields.each do |field|
        if multiple?(field)
          class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{field.to_s.singularize}_uris=(uris)
              raise(ArgumentError, "argument must be an array") unless uris.kind_of?(Array)
              uris.keep_if(&:present?)
              self.send("#{field}=", uris.map { |x| ::RDF::URI(x) })
            end
            def #{field.to_s.singularize}_uris
              self.send("#{field}").map(&:uri).map(&:to_s)
            end
          CODE

        else
          class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{field}_uri=(uri)
              resource = uri.present? ? ::RDF::URI(uri) : nil
              self.send("#{field}=", resource)
            end
            def #{field}_uri
              return unless self.send("#{field}")
              self.send("#{field}").uri.to_s
            end
          CODE
        end
      end
    end
  end
end
