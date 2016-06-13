// Controls the display of the "Files" tab when creating new assets

function disableFilesTab() {
  var tab = $('ul[role="tablist"] li')[1]
  $(tab).addClass("disabled");
}

function enableFilesTab() {
  var tab = $('ul[role="tablist"] li')[1]
  $(tab).removeClass("disabled");
}

Blacklight.onLoad(function() {

  // Disable the files tab when the page is loaded. It is only present for #new actions	
  if ($('select#asset_type_select').length) {
    if ($('select#asset_type_select option:selected').text() === "") {
      disableFilesTab();
    }
  }

  $('a[href="#files"]').on('click', function(evt) {
    if ($('select#asset_type_select').length) {
      if ($('select#asset_type_select option:selected').text() === "") {
        evt.preventDefault();
        return false;
      }
    }
  });

  $('select#asset_type_select').change(function(evt) {
    if (evt.target.selectedIndex > 0) {
      enableFilesTab();
      $('#generic_work_asset_type').val($(evt.target.selectedOptions).val());
    }
    else {
      disableFilesTab();	
      $('#generic_work_asset_type').val("");
    }
  });  

});