# frozen_string_literal: true
class Ability
  include Hydra::Ability
  include CurationConcerns::Ability
  include Sufia::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns,
                         :admin_abilities,
                         :departments_can_read_assets,
                         :users_can_edit_citi_resources
                        ]

  def admin_abilities
    return unless admin?
    can :manage, :all
    can :read, SolrDocument
  end

  def departments_can_read_assets
    can :read, GenericWork do |obj|
      !obj.department?
    end
  end

  def users_can_edit_citi_resources
    can :edit, [Work, Exhibition, Agent, Transaction, Shipment, Place] if registered_user?
  end

  # Overrides Sufia::Ability to enable updates of uploaded files
  def uploaded_file_abilities
    super
    can :update, [Sufia::UploadedFile]
  end
end
