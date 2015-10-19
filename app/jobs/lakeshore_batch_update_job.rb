class LakeshoreBatchUpdateJob < BatchUpdateJob

  def update_file(gf, user)
    gf.pref_label = gf.id if user.can?(:edit, gf)
    super
  end

end
