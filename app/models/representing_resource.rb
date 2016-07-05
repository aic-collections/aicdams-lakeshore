# frozen_string_literal: true
class RepresentingResource
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def representing?
    !(documents.empty? && preferred_representation.nil? && representations.empty?)
  end

  def documents
    @documents ||= objects_with_predicate(:documents_ssim)
  end

  def preferred_representation
    @preferred_representation ||= object_with_predicate(:preferred_representation_ssim)
  end

  def representations
    @representations ||= objects_with_predicate(:representations_ssim)
  end

  private

    def objects_with_predicate(solr_field)
      return [] if id.nil?
      ActiveFedora::Base.where(solr_field => id)
    end

    def object_with_predicate(solr_field)
      return if id.nil?
      ActiveFedora::Base.where(solr_field => id).first
    end
end
