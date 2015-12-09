Blacklight.onLoad(function() {

  function getUrlForAction(link) {
    if (link.data("action") === "new") {
      return ROOT_PATH+link.data("class")+'/'+link.data("list")+'/list_items/new';
    }
    else {
      return ROOT_PATH+link.data("class")+'/'+link.data("list")+'/list_items/'+link.data("id")+'/edit';
    }
  }

  // Open modal to add new list items
  $('.btn.list_item').on('click', function(event) {

    var url = getUrlForAction($(this));
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
