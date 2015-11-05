module Status
  extend ActiveSupport::Concern

  included do

    def active?
      self.status.first == StatusType.active
    end

    def invalid?
      self.status.first == StatusType.invalid
    end
    
    def archived?
      self.status.first == StatusType.archived
    end
    
    def disabled?
      self.status.first == StatusType.disabled
    end
    
    def deleted?
      self.status.first == StatusType.deleted
    end

    # Normally, has_and_belongs_to_many creates this, but we don't need the Solr relations
    # so we create a setter method manually.
    def status_ids=(*args)
      self.status = args.map { |id| StatusType.find(id).first }.compact
    end

  end
end
