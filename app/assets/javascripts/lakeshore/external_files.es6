// Monitors the form for external resources

export class ExternalFiles {
  constructor(form, callback) {
    this.form = form
    $('.external-files').bind('change', callback)
  }

  get hasFiles() {
    let externalFields = this.form.find('input.external-files')
    return externalFields.val() != ''
  }
}
