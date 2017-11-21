export class DeletedFiles {
  // Monitors the form and runs the callback if the delete button in the fileupload is clicked
  constructor(form, callback) {
    this.form = form
    $('#fileupload').bind('fileuploaddestroyed', callback)
  }
}
