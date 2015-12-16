class CommentSelectInput < MultiValueInput
  attr_accessor :html

  protected

    # Delegate this completely to the form.
    def collection
      @collection ||= Array.wrap(object[attribute_name]).reject { |value| value.to_s.strip.blank? }
    end

    def build_field(value, index)
      @html = ''
      options = build_options(input_html_options.dup)
      @rendered_first_element = true
      build_components(attribute_name, value, index, options)
      hidden_id_field(value, index) unless value.new_record?
      @html
    end

    def build_options(options)
      options[:required] = nil if @rendered_first_element
      options[:data] = { attribute: attribute_name }
      options[:class] ||= []
      options[:class] += ["#{input_dom_id} form-control multi-text-field"]
      options[:'aria-labelledby'] = label_id
      options
    end

    # Any changes to this markup will also need to be made in app/assets/javascripts/comments.js
    def build_components(attribute_name, value, index, options)
      field_value = value.send(:content)
      field_name = singular_input_name_for(attribute_name, index, :content)
      @html << @builder.text_field(field_name, options.merge(value: field_value, name: field_name))

      @html << category_button(attribute_name, value) unless field_value.nil?

      # hidden field to trigger removal
      destroy_field_name = destroy_name_for(attribute_name, index)
      @html << @builder.hidden_field(attribute_name, name: destroy_field_name, id: id_for(attribute_name, index, '_destroy'.freeze), value: "false", data: { destroy: true })
    end

    def hidden_id_field(value, index)
      name = id_name_for(attribute_name, index)
      id = id_for(attribute_name, index, 'id'.freeze)
      hidden_value = value.new_record? ? '' : value.id
      @html << @builder.hidden_field(attribute_name, name: name, id: id, value: hidden_value, data: { id: 'remote' })
    end

    # TODO: not needed?
    def category_button(attribute_name, value)
      class_name = attribute_name.to_s.match("aictags") ? "tags" : attribute_name.to_s
      <<-EOF
<span class="input-group-btn">
  <button class="btn btn-default category" data-id="#{value.id}" data-class="#{class_name}">
    <i class="icon-white glyphicon-plus"></i>
    <span>Category</span>
  </button>
</span>
EOF
    end

    def name_for(attribute_name, index, field)
      "#{@builder.object_name}[#{attribute_name}_attributes][#{index}][#{field}][]"
    end

    def id_name_for(attribute_name, index)
      singular_input_name_for(attribute_name, index, "id")
    end

    def destroy_name_for(attribute_name, index)
      singular_input_name_for(attribute_name, index, "_destroy")
    end

    def singular_input_name_for(attribute_name, index, field)
      "#{@builder.object_name}[#{attribute_name}_attributes][#{index}][#{field}]"
    end

    def id_for(attribute_name, index, field)
      [@builder.object_name, "#{attribute_name}_attributes", index, field].join('_'.freeze)
    end
end
