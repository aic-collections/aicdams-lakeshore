# frozen_string_literal: true
# Include this module into ActiveFedora::Base classes to implement Lakeshore's own visibility scheme.
# Building off of Hydra::AccessControls::Visibility, this overrides the necessary methods to add
# an additional department visibility component.
module Permissions::LakeshoreVisibility
  extend ActiveSupport::Concern

  PERMISSION_TEXT_VALUE_DEPARTMENT = "department"
  VISIBILITY_TEXT_VALUE_DEPARTMENT = "department"

  included do
    # Overrides Hydra::AccessControls::Visibility adding a new departmental visibility as well as
    # allowing only specific model types to be private.
    def visibility=(value)
      return if value.nil?
      # only set explicit permissions
      case value
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        public_visibility! && publishable!
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
        registered_visibility! && unpublishable!
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
        private_visibility! && unpublishable!
      when VISIBILITY_TEXT_VALUE_DEPARTMENT
        department_visibility! && unpublishable!
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
      elsif read_groups.include? PERMISSION_TEXT_VALUE_DEPARTMENT
        VISIBILITY_TEXT_VALUE_DEPARTMENT
      else
        default_visibility
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
      [PERMISSION_TEXT_VALUE_DEPARTMENT, department_uid].compact
    end

    def department_uid
      return unless dept_created
      dept_created.citi_uid
    end

    # Only collections may be private
    def private_visibility!
      super if is_a?(Collection)
      errors[:visibility] = "cannot be #{Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE}"
    end

    def default_visibility
      if is_a? Collection
        Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
      else
        VISIBILITY_TEXT_VALUE_DEPARTMENT
      end
    end

    def publishable!
      return unless respond_to?(:publishable)
      self.publishable = true
    end

    def unpublishable!
      return unless respond_to?(:publishable)
      self.publishable = false
    end
end
