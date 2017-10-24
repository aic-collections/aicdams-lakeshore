# frozen_string_literal: true
require 'rails_helper'
require 'cancan/matchers'

describe Sufia::Ability do
  let(:depositor)       { create(:user1) }
  let(:different_user)  { create(:user2) }
  let(:admin)           { create(:admin) }
  let(:department_user) { create(:department_user) }

  subject { Ability.new(depositor) }

  describe "non-assets" do
    let(:non_asset) { create(:non_asset) }
    let(:solr_doc)  { SolrDocument.new(non_asset.to_solr) }

    context "with users" do
      subject { Ability.new(different_user) }

      it { is_expected.to be_able_to(:read, non_asset) }
      it { is_expected.to be_able_to(:edit, non_asset) }
      it { is_expected.to be_able_to(:read, solr_doc) }
      it { is_expected.to be_able_to(:edit, solr_doc) }

      it { is_expected.not_to be_able_to(:delete, non_asset) }
      it { is_expected.not_to be_able_to(:create, NonAsset) }
    end

    context "with administrators" do
      subject { Ability.new(admin) }

      it { is_expected.to be_able_to(:manage, non_asset) }
      it { is_expected.to be_able_to(:manage, NonAsset) }
    end
  end

  describe "department assets" do
    let(:asset)    { create(:department_asset) }
    let(:file_set) { create(:department_file) }
    let(:solr_doc) { SolrDocument.new(asset.to_solr) }
    let(:file_doc) { SolrDocument.new(file_set.to_solr) }
    let(:fs_pres)  { FileSetPresenter.new(file_doc, subject) }

    context "with the depositor" do
      subject { Ability.new(depositor) }

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, asset.id) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_set.id) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end

    context "with a user from the same department" do
      subject { Ability.new(department_user) }

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, asset.id) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_set.id) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end

    context "with a user from a different department" do
      subject { Ability.new(different_user) }

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }

      it { is_expected.not_to be_able_to([:read, :edit, :delete], asset) }
      it { is_expected.not_to be_able_to([:read, :edit, :delete], asset.id) }
      it { is_expected.not_to be_able_to([:read, :edit, :delete], solr_doc) }
      it { is_expected.not_to be_able_to([:read, :edit, :delete], file_set) }
      it { is_expected.not_to be_able_to([:read, :edit, :delete], file_set.id) }
      it { is_expected.not_to be_able_to([:read, :edit, :delete], file_doc) }
      it { is_expected.not_to be_able_to([:read, :edit, :delete], fs_pres) }
    end

    context "with an admin" do
      subject { Ability.new(admin) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, asset.id) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_set.id) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end
  end

  describe "AIC assets" do
    let(:asset)    { create(:aic_asset) }
    let(:file_set) { create(:file_set) }
    let(:solr_doc) { SolrDocument.new(asset.to_solr) }
    let(:file_doc) { SolrDocument.new(file_set.to_solr) }
    let(:fs_pres)  { FileSetPresenter.new(file_doc, subject) }

    before do
      asset.ordered_members = [file_set]
      asset.save
      file_set.access_control_id = asset.access_control_id
      file_set.save
    end

    context "with a user from the same department" do
      subject { Ability.new(department_user) }

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, asset.id) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_set.id) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end

    context "with a user from a different department" do
      subject { Ability.new(different_user) }

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }
      it { is_expected.to be_able_to(:read, asset) }
      it { is_expected.to be_able_to(:read, file_set) }
      it { is_expected.to be_able_to(:read, solr_doc) }
      it { is_expected.to be_able_to(:read, file_doc) }
      it { is_expected.to be_able_to(:read, fs_pres) }

      it { is_expected.not_to be_able_to([:edit, :delete], asset) }
      it { is_expected.not_to be_able_to([:edit, :delete], solr_doc) }
      it { is_expected.not_to be_able_to([:edit, :delete], file_set) }
      it { is_expected.not_to be_able_to([:edit, :delete], file_doc) }
      it { is_expected.not_to be_able_to([:edit, :delete], fs_pres) }
    end

    context "with an admin" do
      subject { Ability.new(admin) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end
  end

  describe "public assets" do
    let(:asset)    { create(:public_asset) }
    let(:file_set) { create(:file_set) }
    let(:solr_doc) { SolrDocument.new(asset.to_solr) }
    let(:file_doc) { SolrDocument.new(file_set.to_solr) }
    let(:fs_pres)  { FileSetPresenter.new(file_doc, subject) }

    context "with a user from the same department" do
      subject { Ability.new(department_user) }

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, asset.id) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_set.id) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end

    context "with a user from a different department" do
      subject { Ability.new(different_user) }

      before do
        asset.ordered_members = [file_set]
        asset.save
        file_set.access_control_id = asset.access_control_id
        file_set.save
      end

      it { is_expected.to be_able_to(:create, GenericWork) }
      it { is_expected.to be_able_to(:create, FileSet) }
      it { is_expected.to be_able_to(:read, asset) }
      it { is_expected.to be_able_to(:read, file_set) }
      it { is_expected.to be_able_to(:read, solr_doc) }
      it { is_expected.to be_able_to(:read, file_doc) }
      it { is_expected.to be_able_to(:read, fs_pres) }

      it { is_expected.not_to be_able_to([:edit, :delete], asset) }
      it { is_expected.not_to be_able_to([:edit, :delete], solr_doc) }
      it { is_expected.not_to be_able_to([:edit, :delete], file_set) }
      it { is_expected.not_to be_able_to([:edit, :delete], file_doc) }
      it { is_expected.not_to be_able_to([:edit, :delete], fs_pres) }
    end

    context "with an admin" do
      subject { Ability.new(admin) }
      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end
  end

  describe "assets with only visibility and incomplete ACLs" do
    let(:asset)    { create(:incomplete_asset) }
    let(:file_set) { create(:incomplete_file_set) }
    let(:solr_doc) { SolrDocument.new(asset.to_solr) }
    let(:file_doc) { SolrDocument.new(file_set.to_solr) }
    let(:fs_pres)  { FileSetPresenter.new(file_doc, subject) }

    context "with a user from the same department" do
      subject { Ability.new(department_user) }

      it { is_expected.to be_able_to(:manage, asset) }
      it { is_expected.to be_able_to(:manage, asset.id) }
      it { is_expected.to be_able_to(:manage, file_set) }
      it { is_expected.to be_able_to(:manage, file_set.id) }
      it { is_expected.to be_able_to(:manage, solr_doc) }
      it { is_expected.to be_able_to(:manage, file_doc) }
      it { is_expected.to be_able_to(:manage, fs_pres) }
    end
  end

  describe "List resources" do
    let(:list) { create(:list) }
    context "with a user who does not have edit access" do
      subject { Ability.new(depositor) }
      it { is_expected.not_to be_able_to(:edit, list) }
    end
    context "with a user who does have edit access" do
      subject { Ability.new(different_user) }
      it { is_expected.to be_able_to(:edit, list) }
    end
    context "with an admin user" do
      subject { Ability.new(admin) }
      it { is_expected.to be_able_to(:edit, list) }
    end
  end
end
