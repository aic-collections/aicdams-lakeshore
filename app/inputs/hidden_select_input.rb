# frozen_string_literal: true
class HiddenSelectInput < SimpleForm::Inputs::Base
  def input_type
    'hidden_select'
  end

  def input(wrapper_options = nil)
    # default class 'form-control' in wrapper_options conflicts with our select2 styles; can always be added as an html input if desired.
    wrapper_options.delete(:class)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    @builder.hidden_field(attribute_name, merged_input_options)
  end
end
