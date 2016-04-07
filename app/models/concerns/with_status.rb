module WithStatus
  extend ActiveSupport::Concern

  included do
    property :status, predicate: AIC.status, multiple: false, class_name: "StatusType"

    def active?
      status == StatusType.active
    end

    def status_id=(id)
      return unless id.present?
      self.status = StatusType.find(id)
    end
  end
end
