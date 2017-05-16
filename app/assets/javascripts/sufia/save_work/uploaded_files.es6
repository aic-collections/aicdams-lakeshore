// Overrides Sufia to allow external resources to count towards hasFiles
export class UploadedFiles {
  // Monitors the form and runs the callback if any files are added
  constructor(form, callback) {
    this.form = form
    $('#fileupload').bind('fileuploadcompleted', callback)
  }

  get hasFileRequirement() {
    let fileRequirement = this.form.find('li#required-files')
    return fileRequirement.size() > 0
  }

  get hasFiles() {
    let fileField = this.form.find('input[name="uploaded_files[]"]')
    let externalFields = this.form.find('input[name="batch_upload_item[external_resources][]"]')
    return ( fileField.size() > 0 || externalFields.first().val() != "" )
  }

  get hasNewFiles() {
    // In a future release hasFiles will include files already on the work plus new files,
    // but hasNewFiles() will include only the files added in this browser window.
    return this.hasFiles
  }
}
