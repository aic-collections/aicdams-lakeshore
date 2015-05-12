module InputSupport
  extend ActiveSupport::Concern

  # Need this to test inputs, but throws:
  #  `include': wrong argument type Class (expected Module) (TypeError)
  #include RSpec::Rails::HelperExampleGroup

  def input_for(object, attribute_name, options={})
    helper.simple_form_for object, url: '' do |f|
      f.input attribute_name, options
    end
  end
end
