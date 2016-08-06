describe("Selecting document types", function() {
  select_doctype = $.fn.selectDoctype();

  it("loads selectDoctype", function() {
    expect(select_doctype.toString()).toEqual('[object Object]');
  });

  describe("documentSubType", function() {
    it("returns a select for a single upload, without an option", function() {
      var html = select_doctype.documentSubType("generic_work", "first_document_sub_type_uri");
      expect($(html).attr('id')).toEqual("generic_work_first_document_sub_type_uri");
      expect($(html).html()).toEqual("");
    });

    it("returns a select for a single upload, with an option", function() {
      var option = '<option value=""></option>';
      var html = select_doctype.documentSubType("generic_work", "first_document_sub_type_uri", option);
      expect($(html).attr('id')).toEqual("generic_work_first_document_sub_type_uri");
      expect($(html).html()).toEqual(option);
    });

    it("returns a select for a batch upload", function() {
      var html = select_doctype.documentSubType("batch_upload_item", "first_document_sub_type_uri");
      expect($(html).attr('id')).toEqual("batch_upload_item_first_document_sub_type_uri")
    });
  });

  describe("getFormModel", function() {
    it("returns the parameterized name of a GenericWork form model", function() {
      var form = $('<form class="simple_form new_generic_work" id="new_generic_work"></form>')
      expect(select_doctype.getFormModel(form)).toEqual("generic_work")
    });
  });

});
