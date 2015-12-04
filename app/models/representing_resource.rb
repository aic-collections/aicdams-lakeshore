class RepresentingResource

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def representing?
    !(documents.empty? && preferred_representations.empty? && representations.empty? && assets.empty?)
  end

  def documents
    @documents ||= objects_with_predicate(:hasDocument_ssim)
  end

  def preferred_representations
    @preferred_representations ||= objects_with_predicate(:hasPreferredRepresentation_ssim)
  end

  def representations
    @representations ||= objects_with_predicate(:hasRepresentation_ssim)
  end

  def assets
    @assets ||= objects_with_predicate(:hasConstituent_ssim)
  end

  private

    def objects_with_predicate(solr_field)
      if id.nil?
        []
      else
        ActiveFedora::Base.where(solr_field => id)
      end
    end

end
