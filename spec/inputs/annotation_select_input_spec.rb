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

  describe "#category_button" do
    let(:id) { "1234" }
    let(:value) { double("value", id: id) }
    let(:comments) { :comments }
    let(:tags)     { :aictags }
    context "when rendering a comment's category button" do
      subject { input.send(:category_button, comments, value) }
      it { is_expected.to include("data-id=\"#{id}\"") }
      it { is_expected.to include("data-class=\"#{comments}\"") }
    end
    context "when rendering a tag's category button" do
      subject { input.send(:category_button, tags, value) }
      it { is_expected.to include("data-class=\"tags\"") }
    end
  end

end
