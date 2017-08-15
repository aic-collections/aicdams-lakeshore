# frozen_string_literal: true
# Builds a hash of list item labels and uris given a certain list type
class ListOptionsService
  attr_reader :members

  # @param [RDF::URI, String] type
  # @return [Hash]
  def self.call(type)
    new(type).options
  end

  def initialize(type)
    @members = build_members(type)
  end

  def options
    options = {}
    members.map { |t| options[t.pref_label] = ActiveFedora::Base.id_to_uri(t.id) }
    options.sort.to_h
  end

  private

    def build_members(type)
      member_ids(type).map do |id|
        ActiveFedora::SolrService.query("id:#{id}").map { |res| SolrDocument.new(res) }
      end.flatten
    end

    def member_ids(type)
      ActiveFedora::SolrService.query("types_ssim:\"#{type}\"", fl: ["member_ids_ssim"]).map do |hit|
        hit.fetch("member_ids_ssim", nil)
      end.flatten.compact
    end
end
