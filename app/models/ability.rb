class Ability
  include Hydra::Ability
  include Sufia::Ability

  def custom_permissions
    if registered_user?
      can [:create, :edit],             Work  
      can [:create, :destroy, :update], FeaturedWork
    end
  end

end
