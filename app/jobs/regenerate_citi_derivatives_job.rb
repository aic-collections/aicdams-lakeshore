# frozen_string_literal: true
# this class generates only the citi derivatives for a given fileset
class RegenerateCitiDerivativesJob < RegenerateAssetDerivativesJob
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the CurationConcerns.config.working_path
  def perform(file_set, file_id, filepath = nil)
    return if file_set.video? && !CurationConcerns.config.enable_ffmpeg
    filename = CurationConcerns::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath)
    Hydra::Derivatives::ImageDerivatives.create(filename, outputs: citi_outputs(file_set))

    # Reload from Fedora and reindex for thumbnail and extracted text
    file_set.reload
    file_set.update_index
    file_set.parent.update_index if parent_needs_reindex?(file_set)
  end

  def citi_outputs(fileset)
    [
      { label: :citi, format: 'jpg', size: '96x96>', quality: "90", url: derivative_url('citi', fileset) }
    ]
  end

  private

    def derivative_url(destination_name, fileset)
      path = derivative_path_factory.derivative_path_for_reference(fileset, destination_name)
      URI("file://#{path}").to_s
    end

    def derivative_path_factory
      ::DerivativePath
    end
end
