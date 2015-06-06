class TagCatsController < ApplicationController
  include Sufia::Controller

  layout "sufia-one-column"

  before_action :authenticate_user!, except: [:show]
  before_action :has_access?, except: [:show]

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = TagCatPresenter
  self.edit_form_class = TagCatEditForm

  def new
    @tag_cat = TagCat.new
  end

  def edit
    @tag_cat = TagCat.find(params[:id])
    @form = edit_form_class.new(@tag_cat)
  end

  def create
    @tag_cat = TagCat.new
    @tag_cat.apply_depositor_metadata(current_user.email)
    if update_tag_cat
      redirect_to edit_tag_cat_path(@tag_cat)
    else
      flash[:error] = @tag_cat.errors.full_messages.join(",")
      redirect_to new_tag_cat_path
    end
  end

  def update
    @tag_cat = TagCat.find(params[:id])
    if update_tag_cat
      redirect_to edit_tag_cat_path(@tag_cat)
    else
      flash[:error] = @tag_cat.errors.full_messages.join(",")
      redirect_to edit_tag_cat_path(@tag_cat)
    end   
  end

  private

  def update_tag_cat
    return false unless params.has_key? :tag_cat
    attributes = edit_form_class.model_attributes(params[:tag_cat])
    @tag_cat.attributes = attributes
    @tag_cat.save
  end

end
