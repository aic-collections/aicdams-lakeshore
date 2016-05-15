# frozen_string_literal: true
# Class used to query different kinds of List resources
class BaseVocabulary
  def self.all
    return [] unless query
    query.members
  end

  def self.options
    options = {}
    all.map { |t| options[t.pref_label] = t.uri }
    options.sort.to_h
  end
end
