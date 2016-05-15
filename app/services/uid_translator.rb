# frozen_string_literal: true
class UidTranslator
  # Given an AIC-minted uid, translate it to an appropriately treeified uri for Fedora.
  # Example: TX-123456 becomes TX/12/34/56/TX-123456
  # If the provided id doesn't conform to AIC minting specs, then use ActiveFedora's default.
  # @param [String] id
  def self.id_to_uri(id)
    return original_uri(id) unless id =~ /^[A-Z]{2,2}/
    path = id.delete('-')
    (path.scan(/..?/).first(4) + [id]).join('/')
  end

  def self.original_uri(id)
    ActiveFedora::Noid.treeify(id)
  end
end
