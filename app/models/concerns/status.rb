module Status
  extend ActiveSupport::Concern

  included do
    property :status, predicate: AIC.status, multiple: false, class_name: "StatusType"

    def active?
      status == StatusType.active
    end

    def invalid?
      status == StatusType.invalid
    end

    def archived?
      status == StatusType.archived
    end

    def disabled?
      status == StatusType.disabled
    end

    def deleted?
      status == StatusType.deleted
    end

    def status_id=(id)
      return unless id.present?
      self.status = StatusType.find(id)
    end
  end
end
