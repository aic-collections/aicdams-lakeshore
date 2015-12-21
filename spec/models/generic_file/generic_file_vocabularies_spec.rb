require 'rails_helper'

describe GenericFile do
  describe "#digitization_source" do
    it_behaves_like "a vocabulary term restricted to single values", "digitization_source"
  end

  describe "#compositing" do
    it_behaves_like "a vocabulary term restricted to single values", "compositing"
  end

  describe "#light_type" do
    it_behaves_like "a vocabulary term restricted to single values", "light_type"
  end

  describe "#view" do
    it_behaves_like "a vocabulary term that accepts multiple values", "view"
  end

  describe "#document_type" do
    it_behaves_like "a vocabulary term that accepts multiple values", "document_type"
  end

  describe "#tag" do
    it_behaves_like "a vocabulary term that accepts multiple values", "tag"
  end
end
