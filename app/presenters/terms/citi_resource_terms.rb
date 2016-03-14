class CitiResourceTerms < ResourceTerms
  def self.all
    super + [:citi_uid]
  end
end
