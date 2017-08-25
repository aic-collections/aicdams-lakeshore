# frozen_string_literal: true
FactoryGirl.define do
  factory :non_asset, aliases: [:citi_resource] do
    pref_label "Generic CITI Resource"
    uid "NA-999999"
    citi_uid "999999"
  end
end
