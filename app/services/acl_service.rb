# frozen_string_literal: true
class AclService
  attr_reader :asset

  # @param [GenericWork] asset
  def initialize(asset)
    @asset = asset
  end

  def update
    asset.update_index
    asset.file_sets.map do |fs|
      reindex_or_update(fs)
    end
  end

  def reindex_or_update(fs)
    if matching_acls?(fs)
      fs.update_index
    else
      update_acls(fs)
    end
  end

  private

    def matching_acls?(fs)
      asset.access_control_id == fs.access_control_id
    end

    def update_acls(fs)
      fs.access_control_id = asset.access_control_id
      fs.save
    end
end
