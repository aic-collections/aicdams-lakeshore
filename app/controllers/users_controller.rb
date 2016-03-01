class UsersController < ApplicationController
  include Sufia::UsersControllerBehavior

  def index
    @users = user_list
    respond_to do |format|
      format.html
      format.json { render json: @users.to_json }
    end
  end

  private

    def user_list
      if params[:uq].blank?
        User.all.references(:trophies).order(sort_value).page(params[:page]).per(10)
      else
        AICUser.search(params[:uq])
      end
    end
end
