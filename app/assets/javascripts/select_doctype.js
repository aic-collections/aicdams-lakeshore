// Controls the display of the Document type when creating new assets

Blacklight.onLoad(function() {

	var docTypeJson = "/sample_doctypes.json";
	var totalDocTypes;
	//loading json and creating doctype list
	$.getJSON(docTypeJson).done(function(data) {
		var $docTypeList = $("#generic_work_document_type_uri");
		var docVals = [];
		$("#asset_type_select").change(function() {
			var $dropdown = $(this);	
			$docTypeList.html("");	
			$( "#generic_work_first_document_sub_type_uri" ).remove();
			$( "#generic_work_second_document_sub_type_uri" ).remove();	
			$docTypeList.append("<option value=''>Please Select</option>");
			var key = $dropdown.val();
			if (key == 'http://definitions.artic.edu/ontology/1.0/type/StillImage') {
				totalDocTypes = data.asset_types.StillImage.doctypes;
				}
			if (key == 'http://definitions.artic.edu/ontology/1.0/type/Text') {
				totalDocTypes = data.asset_types.Text.doctypes;
				}
		
			for (var i = 0; i < totalDocTypes.length; i++) {
				docVals = totalDocTypes[i];
				$docTypeList.append("<option value=" + docVals['value'] + " label=" + docVals['label'] + ">" + docVals['label'] + "</option>");
			}
		})
		
			
		//creating subtype list
		$("#generic_work_document_type_uri").change(function() {
			var $dropdown = $(this);
			var totalSubtypes = [];
			$( "#generic_work_first_document_sub_type_uri" ).remove();
			$( "#generic_work_second_document_sub_type_uri" ).remove();		
			var key = $dropdown.val();
			var subTypeVals = [];	
			if (key) {
				$("#generic_work_document_type_uri").after(" <select class='select optional form-control form-control' name='generic_work[first_document_sub_type_uri]' id='generic_work_first_document_sub_type_uri'><option value=''></option></select>");
				var $subTypeList = $("#generic_work_first_document_sub_type_uri");
				for (var i = 0; i < totalDocTypes.length; i++) {
					if (key == totalDocTypes[i]['value']) {
						totalSubtypes = totalDocTypes[i].subtypes;
					}
				}
				for (var i = 0; i < totalSubtypes.length; i++) {
					subTypeVals = totalSubtypes[i];
					$subTypeList.append("<option value=" + subTypeVals['value'] + ">" + subTypeVals['label'] + "</option>");
				}
				
				//creating subtype2 list
				$("#generic_work_first_document_sub_type_uri").change(function() {
					var $dropdown = $(this);
					var totalSubtypes2 = [];
					$( "#generic_work_second_document_sub_type_uri" ).remove();
					var key = $dropdown.val();
					var subTypeVals2 = [];
					if (key) {
						for (var i = 0; i < totalSubtypes.length; i++) {
							if (key == totalSubtypes[i]['value']) {
								totalSubtypes2 = totalSubtypes[i]['subtypes'];
							}
						}
						if (totalSubtypes2) {
							$("#generic_work_first_document_sub_type_uri").after(" <select class='select optional form-control form-control' name='generic_work[second_document_sub_type_uri]' id='generic_work_second_document_sub_type_uri'><option value=''></option></select>");
							var $subTypeList2 = $("#generic_work_second_document_sub_type_uri");
							for (var i = 0; i < totalSubtypes2.length; i++) {
								subTypeVals2 = totalSubtypes2[i];
								$subTypeList2.append("<option value=" + subTypeVals2['value'] + ">" + subTypeVals2['label'] + "</option>");
							}
							
						}
					}
				});
			}
		});	
	});

});