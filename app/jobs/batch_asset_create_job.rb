# frozen_string_literal: true
class BatchAssetCreateJob < BatchCreateJob
  # Creates one or more assets using a set of locally uploaded files or external uris.
  # @param [User] user uploading
  # @param [ActionController::Parameters] params from the controller
  # @param [Hash] attributes to apply to all works
  # @param [BatchCreateOperation] log
  def perform(user, params, attributes, log)
    log.performing!

    pref_labels = params.fetch(:pref_label, {})
    uploaded_files = params.fetch(:uploaded_files, [])
    external_file = attributes.delete(:external_file)
    external_file_label = attributes.delete(:external_file_label)

    create_with_files(user, pref_labels, uploaded_files, attributes, log) unless uploaded_files.empty?
    create_with_external_file(user, external_file, external_file_label, attributes, log) if external_file.present?
  end

  private

    def create_with_files(user, pref_labels, uploaded_files, attributes, log)
      uploaded_files.each do |upload_id|
        attributes = attributes.merge(uploaded_files: [upload_id], pref_label: pref_labels[upload_id])
        model = model_to_create(attributes)
        child_log = CurationConcerns::Operation.create!(user: user,
                                                        operation_type: "Create Asset",
                                                        parent: log)
        CreateAssetJob.perform_later(user, model, attributes, child_log)
      end
    end

    def create_with_external_file(user, external_file, label, attributes, log)
      pref_label = label.present? ? label : external_file
      attributes = attributes.merge(external_resources: [external_file], pref_label: pref_label)
      model = model_to_create(attributes)
      child_log = CurationConcerns::Operation.create!(user: user,
                                                      operation_type: "Create Asset",
                                                      parent: log)
      CreateAssetJob.perform_later(user, model, attributes, child_log)
    end
end
