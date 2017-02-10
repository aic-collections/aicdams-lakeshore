# frozen_string_literal: true
class UnauthorizedPresenter
  attr_reader :resource

  def initialize(id)
    @resource = SolrDocument.new(GenericWork.find(id).to_solr)
  end

  delegate :title_or_label, :depositor_full_name, :thumbnail_path, :uid, :id, to: :resource

  def depositor_first_name
    resource.depositor_full_name.split(" ").first
  end
end
