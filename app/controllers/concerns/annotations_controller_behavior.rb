module AnnotationsControllerBehavior
  extend ActiveSupport::Concern

  included do
    include Sufia::Controller

    layout "sufia-one-column"

    before_action :authenticate_user!, except: [:show]
    before_action :has_access?, except: [:show]
    before_action :set_annotation, only: [:update, :edit]
  end

  def edit
    set_edit_form
    render partial: "annotations/modal", form: @form if request.xhr?
  end

  def update
    if update_annotation
      flash[:notice] = "The update was successful"
    else
      flash[:error] = "The update was unsuccessful"
    end
    respond_to do |format|
      format.html { redirect_to action: "edit" }
      format.js   { render nothing: true }
    end
  end

  private

  def update_annotation
    attributes = edit_form_class.model_attributes(params[@annotation.class.to_s.downcase.to_sym])
    @annotation.attributes = attributes
    @annotation.save
  end

  def set_annotation
    @annotation = ActiveFedora::Base.find(params[:id])
    render_500("Incorrect annotation class") unless @annotation.is_a?(Tag) || @annotation.is_a?(Comment)
  end

  def set_edit_form
    @form = edit_form_class.new(@annotation)
  end

end
