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

  private

    # Returns the correct type class for status when loading an object from Solr
    def adapt_single_attribute_value(value, attribute_name)
      if attribute_name == "status"
        return unless value.present?
        id = value.fetch("id", nil)
        return if id.nil?
        StatusType.find(id)
      else
        super
      end
    end
end
