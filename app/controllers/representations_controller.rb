# frozen_string_literal: true
class RepresentationsController < ApplicationController
  layout "bare"

  def show
    render_401 unless presenter
    respond_to do |wants|
      wants.html { presenter }
    end
  end

  protected

    def _prefixes
      @_prefixes ||= super + ['curation_concerns/base']
    end

  private

    def presenter
      @presenter ||= RepresentationPresenterBuilder.new(params[:id], current_ability, request).call
    end
end
