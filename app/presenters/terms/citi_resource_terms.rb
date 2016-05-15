# frozen_string_literal: true
class CitiResourceTerms < ResourceTerms
  def self.all
    super + [:citi_uid]
  end
end
