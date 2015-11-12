class LakeshoreBatchUpdateJob < BatchUpdateJob

  def apply_metadata(gf)
    super
    gf.pref_label = gf.id
  end

end
