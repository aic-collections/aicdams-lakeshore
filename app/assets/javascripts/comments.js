// This adds new comment fields to the edit form.
//
// Duplicated from https://github.com/curationexperts/alexandria-v2/blob/master/app/assets/javascripts/editor.js
//
// It uses handelbars.js to create a template into which are passed a field name, index value
// and class. This returns a new html string with the fields for the comment. 
// The hydra-editor gem takes care of the bulk of the actions such attaching the listeners to the "Add" button 
// and inserting the new field into the html form.
//
// Once inserted, the resulting html form should produce a parameters hash that looks like:
//
// {
//   "comments_attributes" => {
//     "0" => {"content"=>"new comment", "_destroy"=>"0", "id"=>"37f13bdf-a664-4015-b590-4a66850a9ab6"},
//     "1" => {"content"=>"new inserted value", "_destroy"=>"0", "id"=>""}
//   }
// }
// 
// TODOs:
//   - QA needs to be involed to query existing comments
//
//= require hydra-editor/hydra-editor
//= require handlebars-v3.0.3

var source = "<li class=\"field-wrapper input-group input-append\">" +
  "<input class=\"string {{class}} optional form-control generic_file_{{name}} form-control multi-text-field\" name=\"generic_file[{{name}}_attributes][{{index}}][content]\" aria-labelledby=\"generic_file_{{name}}_label\" type=\"text\" id=\"generic_file_generic_file[{{name}}_attributes][{{index}}][content]\">" +
  "<input name=\"generic_file[{{name}}_attributes][{{index}}][id]\" id=\"generic_file_{{name}}_attributes_0_id\" data-id=\"remote\" type=\"hidden\"/>" +
  "<span class=\"input-group-btn field-controls\">" +
    "<button class=\"btn btn-success add\"><i class=\"icon-white glyphicon-plus\"></i><span>Add</span></button>" +
  "</span>" +
"</li>";

var template = Handlebars.compile(source);

function CommentsFieldManager(element, options) {
  HydraEditor.FieldManager.call(this, element, options); // call super constructor.
}

CommentsFieldManager.prototype = Object.create(HydraEditor.FieldManager.prototype,
  {
    createNewField: { value: function($activeField) {
      var fieldName = $activeField.find('input').data('attribute');
      $newField = this.newFieldTemplate(fieldName);
      this.addBehaviorsToInput($newField)
      return $newField
    }},

    /* This gives the index for the editor */
    maxIndex: { value: function() {
      return $(this.fieldWrapperClass, this.element).size();
    }},

    // Overridden because the input is not a direct child of activeField
    inputIsEmpty: { value: function(activeField) {
      return activeField.find('input.multi-text-field').val() === '';
    }},

    newFieldTemplate: { value: function(fieldName) {
      var index = this.maxIndex();
      return $(template({ "name": fieldName, "index": index, "class": "comment_select" }));
    }},

    addBehaviorsToInput: { value: function($newField) {
      $newInput = $('input.multi-text-field', $newField);
      $newInput.focus();
      // TODO: Hook-up QA to this
      //addAutocompleteToEditor($newInput);
      this.element.trigger("managed_field:add", $newInput);
    }},

    // Instead of removing the line, we override this method to add a
    // '_destroy' hidden parameter
    removeFromList: { value: function( event ) {
      event.preventDefault();
      var field = $(event.target).parents(this.fieldWrapperClass);
      field.find('[data-destroy]').val('true')
      field.hide();
      this.element.trigger("managed_field:remove", field);
    }}
  }
);
CommentsFieldManager.prototype.constructor = CommentsFieldManager;

$.fn.manage_comment_fields = function(option) {
  return this.each(function() {
    var $this = $(this);
    var data  = $this.data('manage_fields');
    var options = $.extend({}, HydraEditor.FieldManager.DEFAULTS, $this.data(), typeof option == 'object' && option);

    if (!data) $this.data('manage_fields', (data = new CommentsFieldManager(this, options)));
  })
}

Blacklight.onLoad(function() {
  $('.comment_select.form-group').manage_comment_fields();

  // Open mode to edit comment categories
  $('.btn.category').on('click', function(event) {
    var url = ROOT_PATH+$(this).data("class")+'/'+$(this).data("id")+'/edit';
    var jqxhr = $.get(url)
      .done(function(data) {
        $('#ajax-modal').html(data);
        $('#ajax-modal').modal('show');
        $('.multi_value.form-group').manage_fields();
        $("#ajax-modal form").on("ajax:success", function(e, data, status, xhr) {
          $('#ajax-modal').modal('hide');
        });
        $("#ajax-modal form").on("ajax:error", function(e, data, status, xhr) {
          // TODO: use flash alerts
        });
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        // TODO: use flash alerts
        alert('Error:'+errorThrown);
      });
    event.preventDefault();
  });
  
});
