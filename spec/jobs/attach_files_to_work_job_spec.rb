# frozen_string_literal: true
require 'rails_helper'

describe AttachFilesToWorkJob do
  let(:user)              { create(:user1) }
  let(:file)              { File.open(File.join(fixture_path, "sun.png")) }
  let(:original_file)     { Sufia::UploadedFile.create(file: file, user: user, use_uri: AICType.OriginalFileSet) }
  let(:intermediate_file) { Sufia::UploadedFile.create(file: file, user: user, use_uri: AICType.IntermediateFileSet) }
  let(:master_file)       { Sufia::UploadedFile.create(file: file, user: user, use_uri: AICType.PreservationMasterFileSet) }
  let(:plain_file)        { Sufia::UploadedFile.create(file: file, user: user) }
  let(:asset)             { create(:asset) }

  context "with each of the different use files" do
    let(:types) { asset.file_sets.map(&:type).map { |set| set.map(&:to_s) }.flatten.uniq }
    it "attaches the files to the work and updates them" do
      expect(CharacterizeJob).to receive(:perform_later).exactly(3).times
      described_class.perform_now(asset, [original_file, intermediate_file, master_file])
      asset.reload
      expect(types).to include(AICType.OriginalFileSet, AICType.IntermediateFileSet, AICType.PreservationMasterFileSet)
    end
  end

  context "with no use specified" do
    it "attaches the files to the work and updates them" do
      expect(CharacterizeJob).to receive(:perform_later).once
      described_class.perform_now(asset, [plain_file])
      asset.reload
      expect(asset.file_sets.map(&:class)).to contain_exactly(FileSet)
    end
  end
end
