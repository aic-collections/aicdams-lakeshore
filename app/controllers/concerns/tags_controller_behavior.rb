module TagsControllerBehavior
  extend ActiveSupport::Concern

  included do
    include Sufia::Controller

    layout "sufia-one-column"

    before_action :authenticate_user!, except: [:show]
    before_action :has_access?, except: [:show]
    before_action :set_tag, only: [:update, :edit]
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new
    if update_tag
      flash[:notice] = "A new tag was created"
      redirect_to edit_tag_path(@tag)
    else
      flash[:error] = @tag.errors.full_messages.join(",")
      redirect_to new_tag_path
    end
  end

  def edit
    @form = edit_form_class.new(@tag)
  end

  def update
    if update_tag
      flash[:notice] = "The update was successful"
    else
      flash[:error] = "The update was unsuccessful"
    end
    redirect_to edit_tag_path(@tag)
  end

  private

    def update_tag
      attributes = edit_form_class.model_attributes(params["tag"])
      @tag.attributes = attributes
      @tag.save
    end

    def set_tag
      @tag = ActiveFedora::Base.find(params[:id])
    end

end
