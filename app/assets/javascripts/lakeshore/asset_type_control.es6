// Controls the availability of the asset type select by locking it when files
// have already been uploaded to the staging area. This prevents the user from
// uploading a different asset type if other files are already present.

import { UploadedFiles } from 'lakeshore/uploaded_files'
import { DeletedFiles } from 'lakeshore/deleted_files'

export class AssetTypeControl {
  /**
   * @param {jQuery} element the asset type select input
   */
  constructor(element) {
    this.element = element
    this.form = element.closest('form')
  }

  activate() {
    this.uploads = new UploadedFiles(this.form, () => this.disableSelect())
    this.deletes = new DeletedFiles(this.form, () => this.enableSelect())
  }

  disableSelect() {
    if (this.uploads.hasLocalFiles)
      this.element.prop('disabled', true)
  }

  enableSelect() {
    if (!this.uploads.hasLocalFiles)
      this.element.removeProp('disabled')
  }
}
