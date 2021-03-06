# frozen_string_literal: true
# To keep helper modules better defined, the only methods in SufiaHelper override those
# from the other included modules. New or otherwise unique methods should be placed in
# either ApplicationHelper or a different module that is not included here.
module SufiaHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior
  include Sufia::DashboardHelperBehavior

  def visibility_options(variant)
    options = [
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
      Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    ]
    case variant
    when :restrict
      options.delete_at(0)
      options.reverse!
    when :loosen
      options.delete_at(2)
    end
    options.map { |value| [visibility_text(value), value] }
  end

  def user_display_name_and_key(key)
    agent = AICUser.find_by_nick(key) || Department.find_by_department_key(key)
    return agent.pref_label if agent.is_a?(Department)
    AICUserPresenter.new(agent).display_name
  end

  # @return [True, False]
  # Overrides Sufia::DashboardHelperBehavior to display either on my works or assets shared with me
  def on_my_works?
    (params[:controller] =~ /^my\/[works|shares]/) == 0
  end

  private

    def render_visibility_label(document)
      PermissionBadge.new(document).render
    end
end
