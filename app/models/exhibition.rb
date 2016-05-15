# frozen_string_literal: true
class Exhibition < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors

  def self.aic_type
    super << AICType.Exhibition
  end

  type type + aic_type

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

  property :exhibition_type, predicate: AIC.exhibitionType, multiple: false do |index|
    index.type :integer
    index.as :stored_searchable
  end

  # We don't need to override the writer because these resources are imported from CITI
  def pref_label
    name_official || name_working
  end
end
