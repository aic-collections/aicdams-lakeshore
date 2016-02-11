class ErrorsController < ApplicationController
  layout 'error'

  def routing
    render_404("Route not found: /#{params[:error]}")
  end
end
