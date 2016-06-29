# frozen_string_literal: true
require 'rails_helper'

describe PermissionBadge do
  let(:asset)    { build(:department_asset, id: '1234') }
  let(:solr_doc) { SolrDocument.new(asset.to_solr) }

  subject { described_class.new(solr_doc) }

  context "with a department asset" do
    its(:render) { is_expected.to eq('<span title="Department" class="label label-warning">Department</span>') }
  end
end
