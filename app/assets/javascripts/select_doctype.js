// Controls the display of the Document type when creating new assets

function getAssetType(data, assetType) {
	var totalDocTypes;
	if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/StillImage') {
		totalDocTypes = data.asset_types.StillImage.doctypes;
	}
	if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/Text') {
		totalDocTypes = data.asset_types.Text.doctypes;
	}
	return totalDocTypes;
}

function getListValues(docType, totalDocTypes) {
	var totalSubtypes;
	for (var i = 0; i < totalDocTypes.length; i++) {
		if (docType == totalDocTypes[i]['value']) {
			totalSubtypes = totalDocTypes[i].subtypes;
		}
	}
	return totalSubtypes;	
}

function makeDropdown(selectListForm, selection, totalOptions) {
	if (totalOptions.length) {
		for (var i = 0; i < totalOptions.length; i++) {
			var dataVals = [];
			var selected;
			dataVals = totalOptions[i];
			selectListForm.append("<option value=" + dataVals['value'] + " label=" + dataVals['label'] + ">" + dataVals['label'] + "</option>");
			if (selection == dataVals['value']) {
				selected = i;
				selectListForm.prop('selectedIndex', selected);
			}
		}
	}	
}

Blacklight.onLoad(function() {

	var docTypeJson = "/sample_doctypes.json";
	var totalDocTypes;
	var totalSubtypes;
	var docType;
	
	//loading json and creating doctype list
	$.getJSON(docTypeJson).done(function(data) {
		
		//select asset type, create doctype list
		var docTypeList = $("#generic_work_document_type_uri");
		$("#asset_type_select").change(function() {
			var dropdown = $(this);	
			docTypeList.html("");	
			$( "#generic_work_first_document_sub_type_uri" ).remove();
			$( "#generic_work_second_document_sub_type_uri" ).remove();	
			docTypeList.append("<option value=''>Please Select</option>");
			var key = dropdown.val();
			totalDocTypes = getAssetType(data, key);
			makeDropdown(docTypeList, null, totalDocTypes);
		});
		
			
		//creating subtype list
		$("#generic_work_document_type_uri").change(function() {
			if (totalDocTypes == null) {
				var assetType = $("#generic_work_asset_type").val();
				getAssetType(data, assetType);
			}
			var dropdown = $(this);
			$( "#generic_work_first_document_sub_type_uri" ).remove();
			$( "#generic_work_second_document_sub_type_uri" ).remove();		
			var key = dropdown.val();	
			if (key) {
				$("#generic_work_document_type_uri").after(" <select class='select optional form-control form-control' name='generic_work[first_document_sub_type_uri]' id='generic_work_first_document_sub_type_uri'><option value=''></option></select>");
				var subTypeList = $("#generic_work_first_document_sub_type_uri");
				totalSubtypes = getListValues(key, totalDocTypes);
				makeDropdown(subTypeList, null, totalSubtypes);
			}
			
			//creating subtype2 list
			$("#generic_work_first_document_sub_type_uri").change(function() {
				var dropdown = $(this);
				$( "#generic_work_second_document_sub_type_uri" ).remove();
				var key = dropdown.val();
				var totalSubtypes2;
				totalSubtypes2 = getListValues(key, totalSubtypes);
				if (totalSubtypes2) {
					$("#generic_work_first_document_sub_type_uri").after(" <select class='select optional form-control form-control' name='generic_work[second_document_sub_type_uri]' id='generic_work_second_document_sub_type_uri'><option value=''></option></select>");
					var subTypeList2 = $("#generic_work_second_document_sub_type_uri");
					makeDropdown(subTypeList2, null, totalSubtypes2);
				}
			});
		});	
		
		//asset type already selected
		if ($("#generic_work_asset_type").val() && $('div.generic_work_document_type_uri').data('uri')) {
			var assetType = $("#generic_work_asset_type").val();
			docType = $('div.generic_work_document_type_uri').data('uri');
			docTypeList.html("");
			var totalDocTypes = getAssetType(data, assetType);
			makeDropdown(docTypeList, docType, totalDocTypes);
			
			if ($('div.generic_work_first_document_sub_type_uri').data('uri')) {
				$("#generic_work_document_type_uri").after(" <select class='select optional form-control form-control' name='generic_work[first_document_sub_type_uri]' id='generic_work_first_document_sub_type_uri'></select>");
				
				var totalSubtypes = getListValues(docType, totalDocTypes);
				var subType = $('div.generic_work_first_document_sub_type_uri').data('uri');
				var subTypeList = $("#generic_work_first_document_sub_type_uri");
				
				makeDropdown(subTypeList, subType, totalSubtypes);
				
				if ($('div.generic_work_second_document_sub_type_uri').data('uri')) {
					$("#generic_work_first_document_sub_type_uri").after(" <select class='select optional form-control form-control' name='generic_work[second_document_sub_type_uri]' id='generic_work_second_document_sub_type_uri'></select>");
					
					var totalSubtypes2 = getListValues(subType, totalSubtypes);
					var subType2 = $('div.generic_work_second_document_sub_type_uri').data('uri');
					var subTypeList2 = $("#generic_work_second_document_sub_type_uri");
					makeDropdown(subTypeList2, subType2, totalSubtypes2);
				}
			}
		}
		
	});
});
