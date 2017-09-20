# frozen_string_literal: true
class Ability
  include Hydra::Ability
  include CurationConcerns::Ability
  include Sufia::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns,
                         :admin_abilities,
                         :depositors_can_manage,
                         :department_users_can_manage,
                         :read_file_set_presenters,
                         :users_can_edit_citi_resources
                        ]

  def admin_abilities
    return unless admin?
    can :manage, :all
    can :read, SolrDocument
  end

  def users_can_edit_citi_resources
    can :edit, [Work, Exhibition, Agent, Transaction, Shipment, Place] if registered_user?
  end

  def depositors_can_manage
    can :manage, [GenericWork, SolrDocument, FileSet] do |obj|
      current_user.email == obj.depositor
    end

    can :manage, String do |obj|
      test_edit(obj)
    end
  end

  def department_users_can_manage
    can :manage, [GenericWork, FileSet] do |obj|
      obj.dept_created.citi_uid == current_user.department if obj.dept_created
    end

    can :manage, [SolrDocument, FileSetPresenter] do |obj|
      obj.dept_created_citi_uid == current_user.department
    end

    can :manage, String do |obj|
      doc = ActiveFedora::SolrService.query("id:#{obj}", fl: ["dept_created_citi_uid_ssim"])
      doc.first.fetch("dept_created_citi_uid_ssim", []).first == current_user.department unless doc.empty?
    end
  end

  def read_file_set_presenters
    can :read, [FileSetPresenter] do |obj|
      test_read(obj.id)
    end
  end

  # Overrides Sufia::Ability to enable updates of uploaded files
  def uploaded_file_abilities
    super
    can :update, [Sufia::UploadedFile]
  end
end
