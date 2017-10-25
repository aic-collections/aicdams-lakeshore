// Responsible for monitoring the asset creation and edit forms to ensure all requirements
// are met before the form is submitted. These include:
//   * required metadata
//   * at least one, valid intermediate file
// This is copied heavily from Sufia SaveWorkControl, and overrides all of its functions to match
// the local application's needs.

import { RequiredFields } from 'sufia/save_work/required_fields'
import { ChecklistItem } from 'lakeshore/checklist_item'
import { UploadedFiles } from 'lakeshore/uploaded_files'
import { DeletedFiles } from 'lakeshore/deleted_files'
import { ExternalFiles } from 'lakeshore/external_files'

export class FormValidator {

  /**
   * Build with DOM element that tracks the validation of the form
   */
  constructor (element) {
    this.element = element
    this.form = element.closest('form')
    element.data('form_validator', this)
  }

  /**
   * Keep the form from submitting (if the return key is pressed)
   * unless the form is valid.
   *
   * This seems to occur when focus is on one of the visibility buttons
   */
  preventSubmitUnlessValid() {
    this.form.on('submit', (evt) => {
      if (!this.isValid())
        evt.preventDefault()
    })
  }

  /**
   * Keep the form from being submitted many times.
   *
   */
  preventSubmitIfAlreadyInProgress() {
    this.form.on('submit', (evt) => {
      if (this.isValid())
        this.saveButton.prop('disabled', true)
    })
  }

  /**
   * Is the form for a new object, versus editing an existing object
   */
  get isNew() {
    if ( this.form.length == 0 ) {
      return false
    }
    return this.form.attr('id').startsWith('new')
  }


  initialize () {
    this.requiredFields = new RequiredFields(this.form, () => this.formStateChanged())
    this.uploads = new UploadedFiles(this.form, () => this.formStateChanged())
    this.deletes = new DeletedFiles(this.form, () => this.formStateChanged())
    this.externalFiles = new ExternalFiles(this.form, () => this.formStateChanged())
    this.saveButton = this.element.find(':submit')
    this.requiredMetadata = new ChecklistItem(this.element.find('#required-metadata'))
    this.requiredFiles = new ChecklistItem(this.element.find('#required-files'))
    this.uploadErrors = new ChecklistItem(this.element.find('#upload-errors'))
    this.preventSubmitUnlessValid()
    this.preventSubmitIfAlreadyInProgress()
    $('.multi_value.form-group', this.form).bind('managed_field:add', () => this.formChanged())
    $('.multi_value.form-group', this.form).bind('managed_field:remove', () => this.formChanged())
    $('.files').bind('change', () => this.formChanged())
    this.setInitialState()
  }

  // @todo There's a bug with the code that generates the document type dropdown and the
  // current value is not recognized by this.validateMetadata, so we assume all required
  // metadata is present and validate it when displaying the edit form.
  // @todo we need a way to display the files that the asset currently has so we can validate
  // files during edit.
  setInitialState() {
    this.formChanged()
    if (!this.isNew) {
      this.requiredMetadata.check()
      this.requiredFiles.check()
    }
  }

  // Called when a file has been uploaded, the deposit agreement is clicked or a form field has had text entered.
  formStateChanged() {
    this.saveButton.prop('disabled', !this.isValid())
  }

  // called when a new field has been added to the form.
  formChanged() {
    this.requiredFields.reload()
    this.formStateChanged()
  }

  isValid() {
    let metadataValid = this.validateMetadata()
    let filesValid = this.validateFiles()
    let uploadsValid = this.validateUploads()
    return metadataValid && filesValid && uploadsValid
  }

  // sets the metadata indicator to complete/incomplete
  validateMetadata() {
    if (this.requiredFields.areComplete) {
      this.requiredMetadata.check()
      return true
    }
    this.requiredMetadata.uncheck()
    return false
  }

  // sets the files indicator to complete/incomplete
  validateFiles() {
    if (this.uploads.hasFiles || this.externalFiles.hasFiles) {
      this.requiredFiles.check()
      return true
    }
    if ( !this.uploads.hasErrors && !this.isNew ) {
      this.requiredFiles.check()
      return true
    }
    this.requiredFiles.uncheck()
    return false
  }

  // sets the uploads to complete (no errors) or incomplete (errors)
  validateUploads() {
    if (this.uploads.hasErrors) {
      this.uploadErrors.uncheck()
      return false
    }
    this.uploadErrors.check()
    return true
  }
}
