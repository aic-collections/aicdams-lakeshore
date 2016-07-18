# frozen_string_literal: true
class RepresentationPresenterBuilder
  attr_reader :citi_uid, :ability, :request

  def initialize(citi_uid, ability, request)
    @citi_uid = citi_uid
    @ability = ability
    @request = request
  end

  def call
    return unless resource
    presenter.new(SolrDocument.new(resource), ability, request)
  end

  private

    def presenter
      "#{resource.model}Presenter".constantize
    end

    def resource
      return unless citi_uid
      @resource ||= ActiveFedora::SolrService.query("citi_uid_ssim:#{citi_uid}").first
    end
end
