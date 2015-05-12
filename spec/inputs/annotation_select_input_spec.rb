require 'rails_helper'

describe AnnotationSelectInput, type: :input do

  let(:view) { double() }
  let(:generic_file) { GenericFile.new }
  let(:builder) { SimpleForm::FormBuilder.new(:generic_file, generic_file, view, {}) }
  let(:input) { AnnotationSelectInput.new(builder, :comments, nil, :multi_value, {}) }

  describe "#singular_input_name_for" do
    context "when rendering a comment's input field" do
      let(:attribute_name) { "comments" }
      let(:index) { "0" }
      let(:field) { "content" }
      subject { input.send(:singular_input_name_for, attribute_name, index, field)}
      it { is_expected.to eql "generic_file[comments_attributes][0][content]" }
    end
  end

end
