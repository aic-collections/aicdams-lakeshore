module CommentsControllerBehavior
  extend ActiveSupport::Concern

  included do
    include Sufia::Controller

    layout "sufia-one-column"

    before_action :authenticate_user!, except: [:show]
    before_action :has_access?, except: [:show]
    before_action :set_comment, only: [:update, :edit]
  end

  def edit
    set_edit_form
    render partial: "comments/modal", form: @form if request.xhr?
  end

  def update
    if update_comment
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

  def update_comment
    attributes = edit_form_class.model_attributes(params[@comment.class.to_s.downcase.to_sym])
    @comment.attributes = attributes
    @comment.save
  end

  def set_comment
    @comment = ActiveFedora::Base.find(params[:id])
    render_500("Incorrect comment class") unless @comment.is_a?(Comment)
  end

  def set_edit_form
    @form = edit_form_class.new(@comment)
  end

end
