describe("Asset workflow", function() {
  var asset_workflow = null
  beforeEach(function() {
    loadFixtures('asset_workflow.html');
    var awf = require('lakeshore/asset_workflow');
    asset_workflow = new awf.AssetWorkflow();
    asset_workflow.initialize();
  })

  describe("when the new form is first loaded", function() {
    it("marks the description tab disabled", function() {
      expect(asset_workflow.tab).toHaveClass("disabled")
    })
    it("hides the files button", function() {
      expect(asset_workflow.buttonbar).toBeHidden()
    })
  })

})