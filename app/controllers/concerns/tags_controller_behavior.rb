module TagsControllerBehavior
  extend ActiveSupport::Concern

  included do
    include Sufia::Controller

    layout "sufia-one-column"

    before_action :authenticate_user!, except: [:show]
    before_action :has_access?, except: [:show]
    before_action :set_tag, only: [:update, :edit]
  end

  def edit
    set_edit_form
    render partial: "tags/modal", form: @form if request.xhr?
  end

  def update
    if update_tag
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

  def update_tag
    attributes = edit_form_class.model_attributes(params[@tag.class.to_s.downcase.to_sym])
    @tag.attributes = attributes
    @tag.save
  end

  def set_tag
    @tag = ActiveFedora::Base.find(params[:id])
    render_500("Incorrect tag class") unless @tag.is_a?(Tag) || @tag.is_a?(Comment)
  end

  def set_edit_form
    @form = edit_form_class.new(@tag)
  end

end
