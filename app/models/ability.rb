class Ability
  include Hydra::Ability
  include Sufia::Ability

  def custom_permissions
    if registered_user?
      can [:create, :edit],             Work
      can [:create, :edit],             Actor
      can [:create, :destroy, :update], FeaturedWork
    end

    if current_user.admin?
      can [:create, :index, :edit, :update, :destroy, :show, :add_user, :remove_user], Role
    end
  end

end
