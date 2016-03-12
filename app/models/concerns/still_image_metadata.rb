module StillImageMetadata
  extend ActiveSupport::Concern

  included do
    property :compositing, predicate: AIC.compositing, multiple: false, class_name: "ListItem"

    def compositing_id=(id)
      self.compositing = (id.nil? || id.blank?) ? nil : ListItem.find(id)
    end

    property :light_type, predicate: AIC.lightType, multiple: false, class_name: "ListItem"

    def light_type_id=(id)
      self.light_type = (id.nil? || id.blank?) ? nil : ListItem.find(id)
    end

    property :view, predicate: AIC.view, multiple: true, class_name: "ListItem"

    def view_ids=(ids)
      return if ids.nil?
      self.view = ids.map { |id| ListItem.find(id) }
    end
  end
end
