class FieldMap < ActiveFedora::RDF::FieldMap
  def insert(name, index_field_config, object)
    self[index_field_config.key.to_s] ||= ActiveFedora::RDF::FieldMapEntry.new
    PolymorphicBuilder.new(self[index_field_config.key.to_s], index_field_config, object, name).build
  end

  class PolymorphicBuilder < ActiveFedora::RDF::FieldMap::PolymorphicBuilder
    private

      def delegate_class
        kind_of_af_base? ? ResourceBuilder : ActiveFedora::RDF::FieldMap::PropertyBuilder
      end
  end

  class ResourceBuilder < ActiveFedora::RDF::FieldMap::Builder
    def find_values
      object.send(name).map(&:pref_label)
    end
  end
end
