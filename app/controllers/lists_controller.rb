class ListsController < ApplicationController
  include Breadcrumbs

  class_attribute :presenter_class
  self.presenter_class = ListPresenter
  layout "sufia-one-column"
  before_action :load_resource, only: [:show]
  before_action :build_breadcrumbs

  def index
    @lists = List.all
  end

  def show
    @presenter = presenter
  end

  private

    def load_resource
      @resource = List.find(params[:id])
    end

    def presenter
      presenter_class.new(@resource)
    end
end
