// WIP
describe("Uploaded files", function() {
  //var uploaded_files = null
  //beforeEach(function() {
  //  var form = "<p>bogus</p>";
  //  var uf = require('sufia/uploaded_files');
  //  uploaded_files = new uf.AssetWorkflow(form, "callback");
  //  debugger
  //})

  describe("With no external resources specified", function() {
    var form = $("<form>bogus</form>");
    var uf = require('sufia/save_work/uploaded_files');
    uploaded_files = new uf.UploadedFiles(form, "callback");
    //expect(uploaded_files.hasFiles).toBeFalse;
  });
});
