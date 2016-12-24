# frozen_string_literal: true
require 'rails_helper'

describe DuplicateUploadVerificationService do
  let(:user)          { create(:user) }
  let(:file)          { File.open(File.join(fixture_path, "sun.png")) }
  let(:uploaded_file) { Sufia::UploadedFile.create(file: file, user: user, use_uri: AICType.OriginalFileSet) }
  let(:file_digest)   { "urn:sha1:d7feb9d33aaa99928d6f0c01c4663f801a297e2a" }
  let(:service)       { described_class.new(uploaded_file) }

  subject { service.duplicates }

  context "when no duplicates exist" do
    before { allow(FileSet).to receive(:where).with(digest_ssim: file_digest).and_return([]) }
    it { is_expected.to be_empty }
  end

  context "when duplicates exist" do
    let(:duplicate_file) { double }
    before { allow(FileSet).to receive(:where).with(digest_ssim: file_digest).and_return([duplicate_file]) }
    it { is_expected.to contain_exactly(duplicate_file) }
  end
end
