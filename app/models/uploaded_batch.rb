# frozen_string_literal: true
class UploadedBatch < ActiveRecord::Base
  has_many :uploaded_files, class_name: 'Sufia::UploadedFile'
end
