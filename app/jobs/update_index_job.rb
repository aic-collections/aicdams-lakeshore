class UpdateIndexJob < ActiveFedoraIdBasedJob

  def queue_name
    :resolrize
  end

  def run
    object.update_index
  end

end
