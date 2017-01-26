# frozen_string_literal: true
class UnauthorizedPresenter
  def initialize(id)
    @asset = GenericWork.find(id)
  end

  def depositor_last_name
    @asset.aic_depositor.family_name.nil? ? "" : @asset.aic_depositor.family_name
  end

  def depositor_first_name
    @asset.aic_depositor.given_name.nil? ? "" : @asset.aic_depositor.given_name
  end

  def depositor
    @depositor = depositor_last_name.empty? && depositor_first_name.empty? ? "citi_support@artic.edu" : "#{depositor_first_name} #{depositor_last_name}"
  end

  def title
    @asset.to_solr["title_tesim"].first
  end

  def thumbnail
    @asset.to_solr["thumbnail_path_ss"]
  end

  def message
    "You are not authorized to see this asset. Please contact #{depositor} if you would like to request access to it."
  end
end
