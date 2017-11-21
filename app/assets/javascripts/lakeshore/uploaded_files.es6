// Monitors locally-added files and checks for errors

export class UploadedFiles {
  constructor(form, callback) {
    this.form = $('#lakeshore-form-progress').closest('form')
    $('#fileupload').bind('fileuploadcompleted', callback)
  }

  get hasFiles() {
    return this.hasLocalFiles
  }

  get hasLocalFiles() {
    let fileField = this.form.find('input[name="uploaded_files[]"]')
    if (this.isBatchUpload) {
      return fileField.size() > 0
    }
    else {
      return this.hasIntermediateFileSet
    }
  }

  get hasErrors() {
    return this.fileErrors.size() > 0
  }

  get hasIntermediateFileSet() {
    let roles = this.form.find('.wf-role').map(function() { return $(this).val() })
    return jQuery.inArray('http://definitions.artic.edu/ontology/1.0/type/IntermediateFileSet', roles) != -1
  }

  get isBatchUpload() {
    if ( this.form.length == 0 ) {
      return false
    }
    return this.form.attr('id').startsWith('new_batch')
  }

  get fileErrors() {
    return this.form.find('.label-danger')
  }
}
