class CitiResourcePresenter < AbstractPresenter

  def self.terms
    ResourcePresenter.terms + [:citi_uid]
  end

end
