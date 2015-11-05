class CitiResourceTerms < ResourceTerms

  # TODO: Status for CITI resources is separate from Resources because they are not
  # loaded with the Fedora resource denoting "active" (yet). See #127
  def self.all
    super + [:citi_uid, :status]
  end

end
