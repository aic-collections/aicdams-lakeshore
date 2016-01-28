class RepresentationsController < ApplicationController
  include Sufia::Controller
  layout "sufia-one-column"

  before_action :authenticate_user!
  before_action :has_access?

  def index
    @presenter = RepresentationPresenterBuilder.new(params).call
    render_404("no presenter") unless @presenter
  end
end
