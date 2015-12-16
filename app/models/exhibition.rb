class Exhibition < CitiResource
  include CitiBehaviors

  def self.aic_type
    super << AICType.Exhibition
  end

  type aic_type

  property :start_date, predicate: AIC.startDate, multiple: false do |index|
    index.type :date
    index.as :stored_searchable
  end

  property :end_date, predicate: AIC.endDate, multiple: false do |index|
    index.type :date
    index.as :stored_searchable
  end

  property :name_official, predicate: AIC.nameOfficial, multiple: false do |index|
    index.as :stored_searchable
  end

  property :name_working, predicate: AIC.nameWorking, multiple: false do |index|
    index.as :stored_searchable
  end

  property :type_uid, predicate: AIC.exhibitionTypeUid, multiple: false do |index|
    index.type :integer
    index.as :stored_searchable
  end
end
