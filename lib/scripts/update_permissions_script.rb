# frozen_string_literal: true
class UpdatePermissionsScript
  attr_reader :csv_file, :group

  def initialize(csv_file:, group:)
    @csv_file = csv_file
    @group = group
  end

  def assets
    @assets ||= uids.map { |uid| solr_document(uid) }
  end

  def check
    "#{missing_assets.count} assets don't exist"
  end

  def run
    assets.each do |asset|
      if asset.id.present? && needs_permission_change?(asset)
        AddEditGroupPermissionJob.perform_later(id: asset.id, group: group)
      end
    end
  end

  private

    def rows
      @rows ||= CSV.read(csv_file, col_sep: "\t", encoding: "ISO8859-1")
    end

    def uids
      rows.map(&:last).uniq
    end

    def service
      @service ||= UidMinter.new
    end

    def solr_document(uid)
      SolrDocument.find(service.hash(uid))
    rescue Blacklight::Exceptions::RecordNotFound
      SolrDocument.new
    end

    def missing_assets
      assets.select { |asset| asset.id.nil? }
    end

    def needs_permission_change?(asset)
      !asset.edit_groups.include?(group)
    end
end
