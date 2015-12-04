module CitiResourceBehavior
  extend ActiveSupport::Concern

  included do
    include Sufia::Controller
    include Breadcrumbs

    layout "sufia-one-column"

    before_action :authenticate_user!, except: [:index, :show]
    before_action :has_access?, except: [:show]
    before_action :load_resource, only: [:update, :edit, :show]
    before_action :build_breadcrumbs

    # TODO
    #load_and_authorize_resource except: [:index, :show]
  end

  def index
    redirect_to catalog_index_path(params.except(:controller, :action).merge(f: { Solrizer.solr_name("aic_type", :facetable) => [self.class.to_s.gsub(/sController/,"")] }))
  end

  def edit
    @form = edit_form_class.new(@resource)
    render template: "citi_resources/edit"
  end

  def update
    if update_resource
      flash[:notice] = "The update was successful"
    else
      flash[:error] = "The update was unsuccessful"
    end
    redirect_to resource_edit_path
  end

  def show
    @presenter = presenter
    render template: "citi_resources/show"
  end

  private

    def update_resource
      attributes = edit_form_class.model_attributes(params[@resource.class.to_s.downcase])
      @resource.attributes = attributes
      @resource.save
    end

    def load_resource
      @resource = ActiveFedora::Base.find(params[:id])
    end
    
    def presenter
      presenter_class.new(@resource)
    end

    def resource_edit_path
      send("edit_#{@resource.class.to_s.downcase}_path", @resource)
    end

end
