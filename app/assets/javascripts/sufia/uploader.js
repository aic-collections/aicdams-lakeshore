//= require fileupload/tmpl
//= require fileupload/jquery.iframe-transport
//= require fileupload/jquery.fileupload.js
//= require fileupload/jquery.fileupload-process.js
//= require fileupload/jquery.fileupload-validate.js
//= require fileupload/jquery.fileupload-ui.js
//

// Overrides Sufia uploader.js to set maxFileSize and maxNumberOfFiles

/*
 * jQuery File Upload Plugin JS Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

(function( $ ){
  'use strict';

  $.fn.extend({
    sufiaUploader: function( options ) {
      // Initialize our jQuery File Upload widget.
      this.fileupload($.extend({
        sequentialUploads: false,
        limitConcurrentUploads: 6,
        maxNumberOfFiles: 150,
        maxFileSize: 3000000000, // bytes, i.e. 3 GB
        autoUpload: false,
        url: '/uploads/',
        type: 'POST',
        dropZone: $(this).find('.dropzone')
      }, options))
      .bind('fileuploadadded', function (e, data) {
        $(e.currentTarget).find('button.cancel').removeClass('hidden');
        $(e.currentTarget).find('div#all_files').removeClass('hidden');
      })
      .bind('fileuploadcompleted', function (e, data) {
        if ($('button.start').length == 0)
          $(e.currentTarget).find('div#all_files').addClass('hidden');
      });

      $(document).bind('dragover', function(e) {
        var dropZone = $('.dropzone'),
            timeout = window.dropZoneTimeout;
        if (!timeout) {
            dropZone.addClass('in');
        } else {
            clearTimeout(timeout);
        }
        var found = false,
            node = e.target;
        do {
            if (node === dropZone[0]) {
                found = true;
                break;
            }
            node = node.parentNode;
        } while (node !== null);
        if (found) {
            dropZone.addClass('hover');
        } else {
            dropZone.removeClass('hover');
        }
        window.dropZoneTimeout = setTimeout(function () {
            window.dropZoneTimeout = null;
            dropZone.removeClass('in hover');
        }, 100);
      });

      $('button.all').on('click', function(event) {
        event.preventDefault();
        $('button.start').click();
      });
    }
  });
})(jQuery);
