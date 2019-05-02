# frozen_string_literal: true
class Report
  attr_reader :table

  def initialize(file)
    @table = CSV.read(file, headers: true)
  end

  def sets
    @sets ||= table.group_by { |row| row['imaging_uid'] }
  end

  def call
    sets.map do |_uid, set|
      preferred_representation = set
                                 .select { |row| row['preferred_representation'] }
                                 .map { |row| row['preferred_representation'] }.first
      asset_to_keep = set.max_by { |row| row['master_height'].to_i }
      assets_to_delete = set.reject { |row| row['uid'] == asset_to_keep['uid'] }
      update(asset: asset_to_keep, preferred_representation: preferred_representation)
      delete(assets_to_delete)
    end
  end

  def update(asset:, preferred_representation: nil)
    puts "Update #{asset['uid']}"
  end

  def delete(assets)
    puts "Delete #{assets.map { |row| row['uid'] }.join(', ')}"
  end
end
