module LakeshoreVisibility
  extend ActiveSupport::Concern

  # from Hydra::AccessControls::AccessRight
  PERMISSION_TEXT_VALUE_DEPARTMENT = "department".freeze
  VISIBILITY_TEXT_VALUE_DEPARTMENT = "department".freeze

  included do
    # Overrides Hydra::AccessControls::Visibility to allow only registered or department visibilities
    def visibility=(value)
      return if value.nil?
      # only set explicit permissions
      case value
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        errors[:visibility] = "cannot be #{Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC}"
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
        registered_visibility!
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
        errors[:visibility] = "cannot be #{Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE}"
      when VISIBILITY_TEXT_VALUE_DEPARTMENT
        department_visibility!
      else
        raise ArgumentError, "Invalid visibility: #{value.inspect}"
      end
    end

    # Overrides Hydra::AccessControls::Visibility to set default visibility to department
    def visibility
      if read_groups.include? Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC
        Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      elsif read_groups.include? Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED
        Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      else
        VISIBILITY_TEXT_VALUE_DEPARTMENT
      end
    end
  end

  private

    def represented_visibility
      super + department_visibility_groups
    end

    def department_visibility!
      visibility_will_change! unless visibility == VISIBILITY_TEXT_VALUE_DEPARTMENT
      remove_groups = represented_visibility - department_visibility_groups
      set_read_groups(department_visibility_groups, remove_groups)
    end

    def department_visibility_groups
      [PERMISSION_TEXT_VALUE_DEPARTMENT, dept_created].compact
    end
end
