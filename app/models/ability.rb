class Ability
  include Hydra::Ability
  include Sufia::Ability

  def custom_permissions
    if registered_user?
      can [:create, :edit],             Work
      can [:create, :edit],             Actor
      can [:create, :edit],             Exhibition
      can [:create, :edit],             Transaction
      can [:create, :edit],             Shipment
    end

    if current_user.admin?
      can [:create, :index, :edit, :update, :destroy, :show, :add_user, :remove_user], Role
    end

    can :read, GenericFile do |obj|
      !obj.department?
    end
  end

end
