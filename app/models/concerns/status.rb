module Status
  extend ActiveSupport::Concern

  included do

    property :status, predicate: AIC.status, multiple: false, class_name: "StatusType"

    def active?
      self.status == StatusType.active
    end

    def invalid?
      self.status == StatusType.invalid
    end
    
    def archived?
      self.status == StatusType.archived
    end
    
    def disabled?
      self.status == StatusType.disabled
    end
    
    def deleted?
      self.status == StatusType.deleted
    end

    def status_id=(id)
      return unless id.present?
      self.status = StatusType.find(id)
    end

  end

  private

    # TODO: This really ought to go into ActiveFedora
    def adapt_single_attribute_value(value, attribute_name)
      if attribute_name == "status"
        return nil unless value["id"].present?
        StatusType.find(value["id"])
      else
        super
      end
    end
end
