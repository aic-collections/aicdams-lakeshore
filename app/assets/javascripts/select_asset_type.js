// Hides file selection buttons until asset type is chosen

Blacklight.onLoad(function () {

  $('#fileupload_selection').addClass("hidden");
  $('#asset_type').change(function() {
    if ($("select option:selected").attr("value").match(/still_image|text/)) {
      $('#fileupload_selection').removeClass("hidden");
    }
    else {
      $('#fileupload_selection').addClass("hidden");
    }
  });

});
