// lakeshore/asset_workflow
// Controls the edit form when creating new assets

export class AssetWorkflow {
  
  constructor () {
    this.tab = $('ul[role="tablist"] li')[1]
    this.buttonbar = $('.fileupload-buttonbar');
  }

  // setup listeners
  initialize () {
    let $this = this;

    // Disable the files tab when the page is loaded. It is only present for #new actions 
    if ($('select#asset_type_select').length) {
      if ($('select#asset_type_select option:selected').text() === "") {
        $this.disableFilesTab();
      }
    }

    $($this.tab).on('click', function(evt) {
      if ($('select#asset_type_select').length) {
        if ($('select#asset_type_select option:selected').text() === "") {
          evt.preventDefault();
          return false;
        }
      }
    });

    $('select#asset_type_select').change(function(evt) {
      if (evt.target.selectedIndex > 0) {
        $this.enableFilesTab();
        $('#hidden_asset_type').val($(evt.target.selectedOptions).val());
      }
      else {
        $this.disableFilesTab();  
        $('#hidden_asset_type').val("");
      }
    });  
  }

  disableFilesTab() {
    $(this.tab).addClass("disabled");
    $(this.buttonbar).hide();
  }

  enableFilesTab() {
    $(this.tab).removeClass("disabled");
    $(this.buttonbar).show();
  }

}