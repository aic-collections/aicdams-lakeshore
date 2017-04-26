# frozen_string_literal: true
require 'rails_helper'

describe CollectionPresenter do
  let(:collection)    { build(:collection, id: "1234") }
  let(:solr_document) { SolrDocument.new(collection.to_solr) }
  let(:ability)       { Ability.new(nil) }
  let(:presenter)     { described_class.new(solr_document, ability) }

  subject { presenter }

  its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
end
