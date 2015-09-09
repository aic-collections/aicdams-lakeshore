class ExhibitionPresenter < AbstractPresenter

  def self.terms
    [
      :start_date,
      :end_date,
      :name_official,
      :name_working,
      :type_uid
    ] + CitiResourcePresenter.terms
  end

end
